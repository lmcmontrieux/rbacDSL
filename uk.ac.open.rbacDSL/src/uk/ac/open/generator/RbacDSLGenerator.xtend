/*
 * generated by Xtext
 */
package uk.ac.open.generator

import java.util.ArrayList
import java.util.List
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import uk.ac.open.rbacDSL.Rbac
import uk.ac.open.rbacDSL.Role
import uk.ac.open.rbacDSL.User
import uk.ac.open.rbacDSL.PolicyElement

/**
 * Generates code from your model files on save.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#TutorialCodeGeneration
 */
class RbacDSLGenerator implements IGenerator {
	
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		val Rbac rbac = resource.contents.head as Rbac;
		for (Role role:rbac.policyElements.filter(typeof(Role))) {
			fsa.generateFile('PPS' + role.name + '.xml', toPPS(role));
			fsa.generateFile('RPS' + role.name + '.xml', toRPS(role));
		}
		fsa.generateFile('users.xml', toURAssignments(rbac));
	}
	
	def toPPS(Role role) {
		'''
		<PolicySet xmlns="urn:oasis:names:tc:xacml:2.0:policy" 
				PolicySetId="PPS:«role.name»:role"
				PolicyCOmbiningAlgId="&policy-combine;permit-overrides">
			<Target>
				<Subjects><AnySubject /></Subjects>
				<Resources><AnyResource /></Resources>
				<Actions><AnyAction /></Actions>
			</Target>
			
			<!-- Permissions specifically for the «role.name» role -->
			<Policy PolicyId="PPS:policy:«role.name»:role"
					RuleCombiningId="&rule-combine;permit-overrides">
				<Target>
					<Subjects><AnySubject /></Subjects>
					<Resources><AnyResource /></Resources>
					<Actions><AnyAction /></Actions>
				</Target>
				«FOR assignment:role.assignments»
				<!-- Permission(s) for resource «assignment.object.name» -->
				<Rule RuleId="Permission:«role.name»:«assignment.object.name»"
						Effect="Permit">
					<Target>
						<Subjects><AnySubject/></Subjects>
						<Resources>
							<Resource>
								<ResourceMatch MatchId="&function;string-match">
									<AttributeValue DataType="&xml;string">«assignment.object.name»</AttributeValue>
									<ResourceAttributeDesignator 
											AttributeId="&resource;resource-id"
											DataType="&xml;string"/>
								</ResourceMatch>
							</Resource>
						</Resources>
						<Actions>
							«FOR action:assignment.actions»
							<Action>
								<ActionMatch Matchid="&function;string-match">
									<AttributeValue
											DataType="&xml;string">«action.name»</AttributeValue>
									<ActionAttributeDesignator
											AttributeId="&action;action-id"
											DataType="&xml;string"/>
								</ActionMatch>
							</Action>
							«ENDFOR»
						</Actions>
					</Target>
				</Rule>
				
				«ENDFOR»
				
			</Policy>
			«FOR parent:role.parent»
			<!-- Include permissions associated with «parent.name» role -->
			<PolicySetIdReference>PPS:«parent.name»:role</PolicySetIdReference>
			«ENDFOR»
		</PolicySet>
		'''
	}
	
	def toRPS(Role role) {
		'''
		<PolicySet xmlns="urn:oasis:names:tc:xacml:2.0:policy"
				PolicySetId="RPS:«role.name»:role"
				PolicyCombiningAlgId="&policy-combine;permit-overrides">
			<Target>
				<Subjects>
					<Subject>
						<SubjectMatch MatchId="&function;string-equal">
							<AttributeValue DataType="&xml;string">«role.name»</AttributeValue>
							<SubjectAttributeDesignator
									AttributeId="urn:attributes:role"
									DataType="&xml;string" />
						</SubjectMatch>
					</Subject>
				</Subjects>
				<Resources><AnyResource /></Resources>
				<Actions><AnyAction /></Actions>
			</Target>
			
			<!-- Use permissions associated with the «role.name» role -->
			<PolicySetIdReference>PPS:«role.name»:role</PolicySetIdReference>
		</PolicySet>
		'''
	}
	
	def toURAssignments(Rbac model) {
		'''
		<Policy xmlns="urn:oasis:names:tc:xacml:2.0:policy"
				PolicyId="Role:Assignment:Policy"
				RuleCOmbiningAlgId="&rule-combine;permit-overrides">
			<Target>
				<Subjects><AnySubject /></Subjects>
				<Resources><AnyResource /></Resources>
				<Actions><AnyAction /></Actions>
			</Target>
			«FOR Role role:model.policyElements.filter(typeof(Role))»
			<!-- Possible assignments of role «role.name» -->
			<Rule RuleId="«role.name»:role:assignment" Effect="Permit">
				<Target>
					<Subjects>
						«FOR User user:findUsers(model, role)»
						<Subject>
							<SubjectMatch MatchId="&function;string-equal">
								<AttributeValue
										DataType="&xml;string">«user.name»</AttributeValue>
								<SubjectAttributeDesignator
										AttributeId="&subject;subject-id"
										DataType="&xml;string" />
							</SubjectMatch>
						</Subject>
						«ENDFOR»
					</Subjects>
					<Resources>
						<Resource>
							<ResourceMatch MatchId="&function;string-equal">
								<AttributeValue
										DataType="&xml;string">«role.name»</AttributeValue>
								<ResourceAttributeDesignator
										AttributeId="urn:attributes:role"
										DataType="&xml;string" />
							</ResourceMatch>
						</Resource>
					</Resources>
					<Actions>
						<Action>
							<ActionMatch MatchId="&function;string-equal">
								<AttributeValue
										DataType="&xml;string">enable</AttributeValue>
								<ActionAttributeDesignator
										AttributeId="&action;action-id"
										DataType="&xml;string" />
							</ActionMatch>
						</Action>
					</Actions>
				</Target>
			</Rule>
			«ENDFOR»
		</Policy>
		'''
	}
	
	def toDSoD(List<Role> roles) {
		'''
		<PolicySet xmlns="urn:oasis:names:tc:xacml:2.0:policy"
				PolicySetId="DSoS:PolicySet"
				PolicyCombiningAlgId="&policy-combine;deny-overrides">
			<Target>
				<Subjects><AnySubject/></Subjects>
				<Resources><AnyResource/></Resources>
				<Actions><AnyAction/></Actions>
			</Target>
			
			
		</PolicySet>
		'''
	}
	
	/**
	 * In a model, returns an (unordered) list of all the Users assign with a particular
	 * role
	 */
	def List<User> findUsers(Rbac model, Role role) {
		var List<User> users = new ArrayList();
		for (User user:model.policyElements.filter(typeof(User))) {
			if (user.roles.contains(role))
				users.add(user);
		}
		return users;
	}
}
/*
* generated by Xtext
*/
package uk.ac.open.ui.quickfix

import org.eclipse.xtext.ui.editor.quickfix.DefaultQuickfixProvider
import org.eclipse.xtext.ui.editor.quickfix.Fix
import org.eclipse.xtext.ui.editor.quickfix.IssueResolutionAcceptor
import org.eclipse.xtext.validation.Issue
import uk.ac.open.rbacDSL.DSoD
import uk.ac.open.rbacDSL.Policy
import uk.ac.open.rbacDSL.Role
import uk.ac.open.rbacDSL.TupleRole
import uk.ac.open.validation.RbacDSLValidator

import static extension uk.ac.open.util.RbacDSLModelUtil.*
import uk.ac.open.rbacDSL.SSoD
import uk.ac.open.rbacDSL.User
import uk.ac.open.rbacDSL.PolicyConstraint

/**
 * Custom quickfixes.
 *
 * see http://www.eclipse.org/Xtext/documentation.html#quickfixes
 */
class RbacDSLQuickfixProvider extends DefaultQuickfixProvider {
	
	@Fix(RbacDSLValidator::DSOD_WITH_SELF)
	def void removeSelfDSoD(Issue issue,
		IssueResolutionAcceptor acceptor
	) {
		acceptor.accept(issue,
			"Remove DSoD constraint", //label
			"Remove DSoD constraint", //description
			"", //icon
			[
				element, context |
				(element as TupleRole).containingDSoDSet.dsod.remove(Integer.parseInt(issue.data.get(0)))
			]
		)
	}
	
	@Fix(RbacDSLValidator::DUPLICATE_ROLE_ASSIGNMENT)
	def void removeDuplicateRole(Issue issue,
		IssueResolutionAcceptor acceptor
	) {
		acceptor.accept(issue,
			"Remove duplicate role assignment", //label
			"Remove duplicate role assignment", //description
			"", //icon
			[
				element, context |
				(element as User).roles.remove(Integer.parseInt(issue.data.get(0)))
			]
		)
	}
	
	@Fix(RbacDSLValidator::DUPLICATE_ROLE_EXTENSION)
	def void removeDuplicateRoleExtension(Issue issue,
		IssueResolutionAcceptor acceptor
	) {
		acceptor.accept(issue,
			"Remove duplicate role extension", //label
			"Remove duplicate role extension", //description
			"", //icon
			[
				element, context |
				(element as Role).parents.remove(Integer.parseInt(issue.data.get(0)))
			]
		)
	}
	
	@Fix(RbacDSLValidator::DUPLICATE_ROLE_REFERENCE)
	def void removeDuplicateRoleReference(Issue issue,
		IssueResolutionAcceptor acceptor
	) {
		acceptor.accept(issue,
			"Remove duplicate role reference", //label
			"Remove duplicate role reference", //description
			"", //icon
			[
				element, context |
				(element as PolicyConstraint).roles.remove(Integer.parseInt(issue.data.get(0)))
			]
		)
	}
	
	@Fix(RbacDSLValidator::EMPTY_DSOD)
	def void removeEmptyDSoDList(Issue issue,
		IssueResolutionAcceptor acceptor
	) {
		acceptor.accept(issue,
			"Remove empty DSoD list", //label
			"Remove empty DSoD list", //description
			"", //icon
			[
				element, context |
				(element as DSoD).containingPolicy.policyElements.remove(element as DSoD)
			]
		)
	}
	
	@Fix(RbacDSLValidator::EMPTY_POLICY)
	def void removeEmptyPolicy(Issue issue,
		IssueResolutionAcceptor acceptor
	) {
		acceptor.accept(issue,
			"Remove empty constraint", //label
			"Remove empty constraint", //description
			"", //icon
			[
				element, context |
				(element as Policy).containingModel.policies.remove(element)
			]
		)
	}
	
	@Fix(RbacDSLValidator::EMPTY_SSOD)
	def void removeEmptySSoDList(Issue issue,
		IssueResolutionAcceptor acceptor
	) {
		acceptor.accept(issue,
			"Remove empty SSoD list", //label
			"Remove empty SSoD list", //description
			"", //icon
			[
				element, context |
				(element as SSoD).containingPolicy.policyElements.remove(element as SSoD)
			]
		)
	}
	
	@Fix(RbacDSLValidator::EMPTY_USER)
	def void removeEmptyUser(Issue issue,
		IssueResolutionAcceptor acceptor
	) {
		acceptor.accept(issue,
			"Remove empty user", //label
			"Remove empty user " + issue.data.get(0), //description
			"", //icon
			[
				element, context |
				(element as User).containingPolicy.policyElements.remove(element as User)
			]
		)
	}
	
	@Fix(RbacDSLValidator::ROLE_EXTENDING_ITSELF)
	def void removeRoleSelfExtension(Issue issue, 
		IssueResolutionAcceptor acceptor
	) {
		acceptor.accept(issue,
			"Remove role from list of parents", //label
			"Remove role " + issue.data.get(1) + " from list of parents", //description
			"", //icon
			[
				element, context |
				(element as Role).parents.remove(Integer.parseInt(issue.data.get(0)))
				
			]
		)
	}
	
	@Fix(RbacDSLValidator::SSOD_WITH_SELF)
	def void removeSelfSSoD(Issue issue,
		IssueResolutionAcceptor acceptor
	) {
		acceptor.accept(issue,
			"Remove SSoD constraint", //label
			"Remove SSoD constraint " + issue.data.get(0), //description
			"", //icon
			[
				element, context |
				(element as TupleRole).containingSSoDSet.ssod.remove(Integer.parseInt(issue.data.get(0)))
			]
		)
	}
}

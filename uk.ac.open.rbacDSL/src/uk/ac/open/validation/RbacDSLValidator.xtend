/*
 * generated by Xtext
 */
package uk.ac.open.validation

import org.eclipse.xtext.validation.Check
import uk.ac.open.rbacDSL.Policy
import uk.ac.open.rbacDSL.RbacDSLPackage
import uk.ac.open.rbacDSL.Role
import uk.ac.open.rbacDSL.TupleRole
import uk.ac.open.rbacDSL.User

import static extension uk.ac.open.util.RbacDSLModelUtil.*
import static extension org.eclipse.xtext.EcoreUtil2.*
import uk.ac.open.rbacDSL.SSoD
import uk.ac.open.rbacDSL.DSoD
import java.util.Arrays
import uk.ac.open.rbacDSL.PolicyConstraint
import java.util.List
import uk.ac.open.rbacDSL.GrantedConstraint
import java.util.ArrayList
import uk.ac.open.rbacDSL.Operation
import uk.ac.open.rbacDSL.ForbiddenConstraint

/**
 * Custom validation rules. 
 *
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 */
class RbacDSLValidator extends AbstractRbacDSLValidator {
	public static val DSOD_CONFLICT = "uk.ac.open.rbacdsl.DSoDConflict"
	public static val DSOD_WITH_SELF = "uk.ac.open.rbacdsl.DSoDWithSelf"
	public static val DUPLICATE_PERMISSION_ASSIGNMENT = "uk.ac.open.rbacdsl.DuplicatePermissionAssignment"
	public static val DUPLICATE_OPERATION_REFERENCE = "uk.ac.open.rbacdsl.DuplicateOperationReference"
	public static val DUPLICATE_ROLE_ASSIGNMENT = "uk.ac.open.rbacdsl.DuplicateRoleAssignment"
	public static val DUPLICATE_ROLE_EXTENSION = "uk.ac.open.rbacdsl.DuplicateRoleExtension"
	public static val DUPLICATE_ROLE_REFERENCE = "uk.ac.open.rbacdsl.DuplicateRoleReference"
	public static val DUPLICATE_USER_REFERENCE = "uk.ac.open.rbacdsl.DuplicateUserReference"
	public static val EMPTY_DSOD = "uk.ac.open.rbacdsl.EmptyDSoD"
	public static val EMPTY_POLICY = "uk.ac.open.rbacdsl.EmptyPolicy"
	public static val EMPTY_ROLE = "uk.ac.open.rbacdsl.EmptyRole"
	public static val EMPTY_SSOD = "uk.ac.open.rbacdsl.EmptySSoD"
	public static val EMPTY_USER = "uk.ac.open.rbacdsl.EmptyUser"
	public static val FORBIDDEN_VIOLATION = "uk.ac.open.rbacdsl.constraint.ForbiddenViolation"
	public static val GRANTED_VIOLATION = "uk.ac.open.rbacdsl.constraint.GrantedViolation"
	public static val MULTIPLE_DSOD_BLOCKS = "uk.ac.open.rbacdsl.MultipleDSoDBlocks"
	public static val MULTIPLE_SSOD_BLOCKS = "uk.ac.open.rbacdsl.MultipleSSoDBlocks"
	public static val ROLE_EXTENDING_ITSELF = "uk.ac.open.rbacdsl.RoleExtendingItself"
	public static val SOD_CONFLICT = "uk.ac.open.rbacdsl.SoDConflict"
	public static val SSOD_WITH_ANCESTOR = "uk.ac.open.rbacdsl.SSoDWithAncestor"
	public static val SSOD_WITH_SELF = "uk.ac.open.rbacdsl.SSoDWithSelf"
	public static val UNASSIGNED_ROLE = "uk.ac.open.rbacdsl.UnassignedRole"
	
	@Check
	def checkDSoDInConstraint(PolicyConstraint const) {
		for (role:const.roles) {
			for (dsod:role.dsodWith) {
				if (const.roles.contains(dsod)) {
					error("DSoD violation with role '" + role.name + "'",
						RbacDSLPackage::eINSTANCE.policyConstraint_Roles,
						const.roles.indexOf(dsod),
						DSOD_CONFLICT
					)
					error("DSoD violation with role '" + dsod.name + "'",
						RbacDSLPackage::eINSTANCE.policyConstraint_Roles,
						const.roles.indexOf(role),
						DSOD_CONFLICT
					)
				}
			}
		}
	}
	
	/**
	 * Verifies that the policies satisfy Granted constraints. To satisfy a 
	 * Granted constraint, the activated roles must provide /all/ the operations
	 * required in the constraint. Each operation that is not provided will be 
	 * highlighted using an error marker
	 */
	@Check
	def checkGrantedConstraint(GrantedConstraint const) {
		val available = getAvailableOperations(const.roles)
		val violations = const.operations.filter[o | !available.contains(o)]
		for(violation:violations) {
			error("Operation '" + violation.name + "' not granted",
				RbacDSLPackage::eINSTANCE.policyConstraint_Operations,
				const.operations.indexOf(violation),
				GRANTED_VIOLATION
			)
		}
	}
	
	/**
	 * Verifies that the policies satisfy Forbidden constraints. To satisfy a 
	 * Forbidden constraint, the activated roles must fail to provide at least 
	 * one operation required in the constraint. The constraint name will be 
	 * highlighted using an error marker.
	 */
	@Check
	def checkForbiddenConstraint(ForbiddenConstraint const) {
		val available = getAvailableOperations(const.roles) {
			val missing = const.operations.filter[o | !available.contains(o)]
			if (missing.isEmpty())
				error("Forbidden constraint '" + const.name + "' violated",
					RbacDSLPackage::eINSTANCE.policyConstraint_Name,
					FORBIDDEN_VIOLATION
				)
		}
	}
	
	/**
	 * From a list of roles, returns a list of operations afforded by those 
	 * roles
	 */
	private def getAvailableOperations(List<Role> roles) {
		var available = new ArrayList<Operation>
		for (role:roles) {
			available.addAll(role.permissions.toArray() as Operation[])
		}
		available.toSet()
	}
	
	/**
	 * Finds roles in constraints that are not /assigned/ to /all/ the users in 
	 * the constraint.
	 * A role cannot be activated by a user if it isn't assigned to the user, 
	 * so any of there roles should trigger an error. The error marker appears 
	 * on the role.
	 */
	@Check
	def checkUnassignedRolesInConstraint(PolicyConstraint constraint) {
		for (user:constraint.users) {
			for (role:checkUnassignedRolesForUser(user, constraint.roles)) {
				error("Role not assigned to user '" + user.name + "'",
					RbacDSLPackage::eINSTANCE.policyConstraint_Roles,
					constraint.roles.indexOf(role),
					UNASSIGNED_ROLE
				)
			}
		}
	}
	
	private def checkUnassignedRolesForUser(User user, List<Role> roles) {
		roles.filter[r | !user.allRoles.toList.contains(r)]
	}
	
	@Check
	def checkEmptyDSoD(DSoD dsod) {
		if (dsod.dsod.size() == 0)
			warning('''Empty DSoD list''',
				RbacDSLPackage::eINSTANCE.DSoD_Dsod,
				EMPTY_DSOD
			)
	}
	
	@Check
	def checkEmptyPolicy(Policy policy) {
		if (policy.policyElements.isEmpty())
			warning('''Empty policy''',
				RbacDSLPackage::eINSTANCE.policy_Name,
				EMPTY_POLICY
			)
	}
	
	@Check
	def checkEmptySSoD(SSoD ssod) {
		if (ssod.ssod.size() == 0)
			warning('''Empty SSoD list''',
				RbacDSLPackage::eINSTANCE.SSoD_Ssod,
				EMPTY_SSOD
			)
	}
	
	@Check
	def checkEmptyUser(User user) {
		if (user.roles.isEmpty())
			warning('''User has no role assignment''',
				RbacDSLPackage::eINSTANCE.user_Name,
				EMPTY_USER,
				user.name
			)
	}
	
	@Check
	def checkEmptyRole(Role role) {
		if (role.permissions.isEmpty())
			warning('''Role has no operations assigned on any object''',
				RbacDSLPackage::eINSTANCE.role_Name,
				EMPTY_ROLE
			)
	}
	
	@Check
	def checkMultipleSSoDBlocks(Policy policy) {
		val ssods = policy.ssod
		if (ssods.size() > 1)
			error('''Several ssod blocks in the same policy''',
				ssods.get(1),
				null,
				MULTIPLE_SSOD_BLOCKS
			)
	}
	
	@Check
	def checkMultipleDSoDBlocks(Policy policy) {
		val dsods = policy.dsod
		if (dsods.size() > 1)
			error('''Several dsod blocks in the same policy''',
				dsods.get(1),
				null,
				MULTIPLE_DSOD_BLOCKS
			)
	}
	
	@Check
	def checkSSoDWithSelf(TupleRole tuple) {
		var int index = tuple.containingSSoDSet.ssod.indexOf(tuple)	
		if (tuple.fst.equals(tuple.snd))
			error('''SSoD constraint between an role and itself''',
				tuple,
				null,
				SSOD_WITH_SELF,
				index.toString
			)
	}
	
	@Check
	def checkDSoDWithSelf(TupleRole tuple) {
		var int index = tuple.containingDSoDSet.dsod.indexOf(tuple)	
		if (tuple.fst.equals(tuple.snd))
			error('''DSoD constraint between an role and itself''',
				tuple,
				null,
				DSOD_WITH_SELF,
				index.toString
			)
	}
	
	/**
	 * There cannot, by definition, be SSoD constraints between a role and one
	 * of its ancestors, as it would prevent the role to ever be assigned to
	 * anybody.
	 */
	@Check
	def checkSSoDWithAncestor(TupleRole tuple) {
		if (tuple.containingSSoDSet != null) {
			if (tuple.fst.ancestors.contains(tuple.snd) || tuple.snd.ancestors.contains(tuple.fst))
				error('''SSoD constraint between a role and one of its ancestors''',
					tuple,
					null,
					SSOD_WITH_ANCESTOR
				)
		}
	}
	
	/**
	 * A role should not extend the same role multiple times
	 */
	@Check
	def checkDuplicateRoleExtensions(Role role) {
		for (var i = 0; i < role.parents.toArray.length; i++) {
			var parent = role.parents.toArray.get(i);
			val previous = Arrays.copyOfRange(role.parents.toArray, 0, i) //subset of parents array before parent
			if (previous.contains(parent)) {
				error('''Duplicate role extension''',
					RbacDSLPackage::eINSTANCE.role_Parents,
					i,
					DUPLICATE_ROLE_EXTENSION
				)
				error('''Duplicate role extension''',
					RbacDSLPackage::eINSTANCE.role_Parents,
					previous.indexOf(parent),
					DUPLICATE_ROLE_EXTENSION
				)
			}
		}
	}
	
	/**
	 * A role should not extend itself
	 */
	 @Check
	 def checkRoleExtendingItself(Role role) {
	 	if (role.parents.contains(role))
	 		error('''Role extending itself''',
	 			role,
	 			null,
	 			ROLE_EXTENDING_ITSELF,
	 			role.parents.indexOf(role).toString,
	 			role.name
	 		)
	 }
	 
	 @Check
	 def checkDuplicateRoleAssignment(User user) {
	 	if (user.roles.size() <= 1)
	 		return;
	 	for (var i = 0; i < user.roles.size(); i++) {
	 		var current = user.roles.get(i)
	 		for (var j = i+1; j < user.roles.size(); j++) {
	 			if (current.equals(user.roles.get(j))) {
	 				error('''Duplicate role assignment''',
	 					RbacDSLPackage::eINSTANCE.user_Roles,
	 					j,
	 					DUPLICATE_ROLE_ASSIGNMENT
	 				)
	 				error('''Duplicate role assignment''',
	 					RbacDSLPackage::eINSTANCE.user_Roles,
	 					i,
	 					DUPLICATE_ROLE_ASSIGNMENT
	 				)	
	 			}
	 		}
	 	}
	 }
	 
	 @Check
	 def checkDuplicateUserReferences(PolicyConstraint constraint) {
	 	if (constraint.users.size() <= 1)
	 		return;
	 	for (var i = 0; i < constraint.users.size(); i++) {
	 		var current = constraint.users.get(i)
	 		for (var j = i+1; j < constraint.users.size(); j++) {
	 			if (current.equals(constraint.users.get(j))) {
	 				error('''Duplicate user reference''',
	 					RbacDSLPackage::eINSTANCE.policyConstraint_Users,
	 					j,
	 					DUPLICATE_USER_REFERENCE
	 				)
	 				error('''Duplicate user reference''',
	 					RbacDSLPackage::eINSTANCE.policyConstraint_Users,
	 					i,
	 					DUPLICATE_USER_REFERENCE
	 				)
	 			}
	 		}
	 	}
	 }
	 
	 @Check
	 def checkDuplicateRoleReferences(PolicyConstraint constraint) {
	 	if (constraint.roles.size() <= 1)
	 		return;
	 	for (var i = 0; i < constraint.roles.size(); i++) {
	 		var current = constraint.roles.get(i)
	 		for (var j = i+1; j < constraint.roles.size(); j++) {
	 			if (current.equals(constraint.roles.get(j))) {
	 				error('''Duplicate role reference''',
	 					RbacDSLPackage::eINSTANCE.policyConstraint_Roles,
	 					j,
	 					DUPLICATE_ROLE_REFERENCE
	 				)
	 				error('''Duplicate role reference''',
	 					RbacDSLPackage::eINSTANCE.policyConstraint_Roles,
	 					i,
	 					DUPLICATE_ROLE_REFERENCE
	 				)
	 			}
	 		}
	 	}
	 }
	 
	 @Check
	 def checkDuplicateOperationReferences(PolicyConstraint constraint) {
	 	if (constraint.operations.size() <= 1)
	 		return;
	 	for (var i = 0; i < constraint.operations.size(); i++) {
	 		var current = constraint.operations.get(i)
	 		for (var j = i+1; j < constraint.operations.size(); j++) {
	 			if (current.equals(constraint.operations.get(j))) {
	 				error('''Duplicate operation reference''',
	 					RbacDSLPackage::eINSTANCE.policyConstraint_Operations,
	 					j,
	 					DUPLICATE_OPERATION_REFERENCE
	 				)
	 				error('''Duplicate operation reference''',
	 					RbacDSLPackage::eINSTANCE.policyConstraint_Operations,
	 					i,
	 					DUPLICATE_OPERATION_REFERENCE
	 				)
	 			}
	 		}
	 	}
	 }
	
	/*
	 * Raises a warning if a DSoD constraint is identical to an SSoD constraint.
	 * In such a case, the DSoD constraint is unnecessary.
	 */
	@Check
	def checkSoDConflict(TupleRole tuple) {
		if (tuple.getContainerOfType(typeof(DSoD)) != null) {
			for (SSoD ssod:tuple.policy.ssod) {
				for (TupleRole current:ssod.ssod) {
					if(current.isEquivalentTo(tuple)) {
						warning('''DSoD constraint unnecessary because of an identical SSoD constraint''',
							tuple,
							null,
							SOD_CONFLICT
						)
					}
				}
			}
		}
	}
	
	/*
	 * Determines if two tuples involve the same two roles
	 */
	private def isEquivalentTo(TupleRole tuple1, TupleRole tuple2) {
		if (((tuple1.fst == tuple2.fst) && (tuple1.snd == tuple2.snd))
			|| ((tuple1.fst == tuple2.snd) && (tuple1.snd == tuple2.fst)))
			return true
		return false
	}
}

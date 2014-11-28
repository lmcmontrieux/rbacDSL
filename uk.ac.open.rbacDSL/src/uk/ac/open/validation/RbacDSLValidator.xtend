/*
 * generated by Xtext
 */
package uk.ac.open.validation

import org.eclipse.xtext.validation.Check
import uk.ac.open.rbacDSL.User
import uk.ac.open.rbacDSL.RbacDSLPackage
import uk.ac.open.rbacDSL.Role

/**
 * Custom validation rules. 
 *
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 */
class RbacDSLValidator extends AbstractRbacDSLValidator {
	public static val EMPTY_USER = "uk.ac.open.rbacdsl.EmptyUser"
	public static val ROLE_NO_ACTIONS = "uk.ac.open.rbacdsl.RoleNoAction"
	
	@Check
	def checkEmptyUsers(User user) {
		if (user.roles.isEmpty())
			warning('''User has no role assignment''',
				RbacDSLPackage::eINSTANCE.policyElement_Name,
				EMPTY_USER
			)
	}
	
	@Check
	def checkRoleNoActions(Role role) {
		if (role.permissions == null)
			warning('''Role has no actions assigned on any object''',
				RbacDSLPackage::eINSTANCE.policyElement_Name,
				ROLE_NO_ACTIONS
			)
	}
}

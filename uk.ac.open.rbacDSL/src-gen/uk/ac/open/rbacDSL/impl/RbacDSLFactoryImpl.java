/**
 */
package uk.ac.open.rbacDSL.impl;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;

import org.eclipse.emf.ecore.impl.EFactoryImpl;

import org.eclipse.emf.ecore.plugin.EcorePlugin;

import uk.ac.open.rbacDSL.*;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model <b>Factory</b>.
 * <!-- end-user-doc -->
 * @generated
 */
public class RbacDSLFactoryImpl extends EFactoryImpl implements RbacDSLFactory
{
  /**
   * Creates the default factory implementation.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public static RbacDSLFactory init()
  {
    try
    {
      RbacDSLFactory theRbacDSLFactory = (RbacDSLFactory)EPackage.Registry.INSTANCE.getEFactory(RbacDSLPackage.eNS_URI);
      if (theRbacDSLFactory != null)
      {
        return theRbacDSLFactory;
      }
    }
    catch (Exception exception)
    {
      EcorePlugin.INSTANCE.log(exception);
    }
    return new RbacDSLFactoryImpl();
  }

  /**
   * Creates an instance of the factory.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public RbacDSLFactoryImpl()
  {
    super();
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public EObject create(EClass eClass)
  {
    switch (eClass.getClassifierID())
    {
      case RbacDSLPackage.RBAC: return createRbac();
      case RbacDSLPackage.POLICY: return createPolicy();
      case RbacDSLPackage.SCENARIOS: return createScenarios();
      case RbacDSLPackage.USER: return createUser();
      case RbacDSLPackage.ROLE: return createRole();
      case RbacDSLPackage.PERMISSION: return createPermission();
      case RbacDSLPackage.RESOURCE: return createResource();
      case RbacDSLPackage.USER_SCENARIO: return createUserScenario();
      case RbacDSLPackage.GRANTED_SCENARIO: return createGrantedScenario();
      case RbacDSLPackage.FORBIDDEN_SCENARIO: return createForbiddenScenario();
      case RbacDSLPackage.USER_ROLE_SCENARIO: return createUserRoleScenario();
      case RbacDSLPackage.RESOURCE_ROLE_SCENARIO: return createResourceRoleScenario();
      case RbacDSLPackage.RESOURCE_SCENARIO: return createResourceScenario();
      default:
        throw new IllegalArgumentException("The class '" + eClass.getName() + "' is not a valid classifier");
    }
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public Rbac createRbac()
  {
    RbacImpl rbac = new RbacImpl();
    return rbac;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public Policy createPolicy()
  {
    PolicyImpl policy = new PolicyImpl();
    return policy;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public Scenarios createScenarios()
  {
    ScenariosImpl scenarios = new ScenariosImpl();
    return scenarios;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public User createUser()
  {
    UserImpl user = new UserImpl();
    return user;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public Role createRole()
  {
    RoleImpl role = new RoleImpl();
    return role;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public Permission createPermission()
  {
    PermissionImpl permission = new PermissionImpl();
    return permission;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public Resource createResource()
  {
    ResourceImpl resource = new ResourceImpl();
    return resource;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public UserScenario createUserScenario()
  {
    UserScenarioImpl userScenario = new UserScenarioImpl();
    return userScenario;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public GrantedScenario createGrantedScenario()
  {
    GrantedScenarioImpl grantedScenario = new GrantedScenarioImpl();
    return grantedScenario;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public ForbiddenScenario createForbiddenScenario()
  {
    ForbiddenScenarioImpl forbiddenScenario = new ForbiddenScenarioImpl();
    return forbiddenScenario;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public UserRoleScenario createUserRoleScenario()
  {
    UserRoleScenarioImpl userRoleScenario = new UserRoleScenarioImpl();
    return userRoleScenario;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public ResourceRoleScenario createResourceRoleScenario()
  {
    ResourceRoleScenarioImpl resourceRoleScenario = new ResourceRoleScenarioImpl();
    return resourceRoleScenario;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public ResourceScenario createResourceScenario()
  {
    ResourceScenarioImpl resourceScenario = new ResourceScenarioImpl();
    return resourceScenario;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public RbacDSLPackage getRbacDSLPackage()
  {
    return (RbacDSLPackage)getEPackage();
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @deprecated
   * @generated
   */
  @Deprecated
  public static RbacDSLPackage getPackage()
  {
    return RbacDSLPackage.eINSTANCE;
  }

} //RbacDSLFactoryImpl

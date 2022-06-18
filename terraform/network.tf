##############################################################Note#####################################################################################
# Below code will allow you to create <network> account in <SharedOU> that will be used for creating Transit Gateway and IPAM Pool within this account#
# You can change attributes per your requirements and same will used while provisioning the account.                                                #
# Pre-requisite for executing this script is ManagedOrganizationalUnit should already been created.                                                   #
#######################################################################################################################################################

module "network" { #Create a new module resource for every new account you want to provision ,You can  define module name as per your requirement
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "asumedh+networktgw@amazon.com" #Account email must be unique and you should be able to verify account through email, Usage :- user+accountname@domain
    AccountName               = "networktgw" # Account Name
    ManagedOrganizationalUnit = "SharedService (ou-4uhe-rxqd3odi)" #if you are using nested OUs, include the OU ID in parentheses, such as Sandbox (ou-44...)
    SSOUserEmail              = "asumedh+networktgw@amazon.com" #Account email must be unique and you should be able to verify through email id specfied
    SSOUserFirstName          = "sumedh" #You can specify user first name 
    SSOUserLastName           = "Ambapkar" #You can specify user last name 
  }

  account_tags = {
    "Learn Tutorial" = "AFT"      #You can specify required tags for your account
  }

  change_management_parameters = {     #You can specify Change Management attribute that will help you getting some more details w.r.t Change Management
    change_requested_by = "HashiCorp Learn"
    change_reason       = "Learn AWS Control Tower Account Factory for Terraform"
  }

  custom_fields = { #Custom fields are use to store defined attributes in parameter store in account provisioned as key value pair ,This parameters while be utilized if required while executing code from account customizations
    # Below example demonstrate IPAM CIDR set in parameter store in network account for different IPAM pool like PROD and DEV
    prd_ipam_cidr = "10.102.0.0/16"  #Set IPAM CIDR as per your requirement, This attribute will be stored in parameter Store of newly network account created
    dev_ipam_cidr = "10.104.0.0/16"  #Set IPAM CIDR as per your requirement, This attribute will be stored in parameter Store of newly network account created
  }
  
  #Below attribute will execute code in network folder of account customizations repository which is for creation of TransitGateway and IPAM
  account_customizations_name = "network"  #attribute lets you specify the subdirectory in the account customizations repository the pipeline should use to modify this account, if any
}

##############################################################Note###############################################################################################
# Below code will allow you to create accounts in existing OU and also you can specify customization for creating required resources within the account like VPC#                 
# You can change attributes per your requirements and same will used while provisioning the account.                                                            #
# Pre-requisite for executing this script is ManagedOrganizationalUnit should already been created.                                                             #
#################################################################################################################################################################
module "bu-prod" { #Create a new module resource for every new account you want to provision ,You can  define module name as per your requirement
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "asumedh+prodbuone@amazon.com" #Account email must be unique and you should be able to verify account through email, Usage :- user+accountname@domain
    AccountName               = "prodbuone" # Account Name
    ManagedOrganizationalUnit = "Prod (ou-4uhe-xabhcjk2)" #f you are using nested OUs, include the OU ID in parentheses, such as Sandbox (ou-44...)
    SSOUserEmail              = "asumedh+prodbuone@amazon.com" #Account email must be unique and you should be able to verify through email id specfied
    SSOUserFirstName          = "asumedh" #You can specify user first name 
    SSOUserLastName           = "Ambapkar" #You can specify user last name 
  }

  account_tags = {  #You can specify required tags for your account
    "Learn Tutorial" = "AFT"
  }

  change_management_parameters = { #You can specify Change Management attribute that will help you getting some more details w.r.t Change Management
    change_requested_by = "HashiCorp Learn"
    change_reason       = "Learn AWS Control Tower Account Factory for Terraform"
  }

  custom_fields = {} #Custom fields are use to store defined attributes in parameter store in account provisioned as key value pair ,This parameters while be utilized if required while executing code from account customizations
  
  #Below attribute will execute code in workload folder of account customizations repository which is for creation of VPC ,Subnets and Attaching those to TGW.
  account_customizations_name = "workload"
}
module "bu-dev" { #Create a new module resource for every new account you want to provision ,You can  define module name as per your requirement
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "asumedh+devone@amazon.com" #Account email must be unique and you should be able to verify account through email, Usage :- user+accountname@domain
    AccountName               = "Devone" # Account Name
    ManagedOrganizationalUnit = "Development (ou-4uhe-u1avwiyp)" #f you are using nested OUs, include the OU ID in parentheses, such as Sandbox (ou-44...)
    SSOUserEmail              = "asumedh+devone@amazon.com" #Account email must be unique and you should be able to verify through email id specfied
    SSOUserFirstName          = "asumedh" #You can specify user first name
    SSOUserLastName           = "Ambapkar" #You can specify user last name
  }

  account_tags = {  #You can specify required tags for your account
    "Learn Tutorial" = "AFT"
  }

  change_management_parameters = { #You can specify Change Management attribute that will help you getting some more details w.r.t Change Management
    change_requested_by = "HashiCorp Learn"
    change_reason       = "Learn AWS Control Tower Account Factory for Terraform"
  }

  custom_fields = {} #Custom fields are use to store defined attributes in parameter store in account provisioned as key value pair ,This parameters while be utilized if required while executing code from account customizations

  #Below attribute will execute code in workload folder of account customizations repository which is for creation of VPC ,Subnets and Attaching those to TGW.
  account_customizations_name = "workload"
}

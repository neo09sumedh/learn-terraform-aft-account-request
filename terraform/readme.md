# Deploying accounts using AFT 

# Sections 
  1. Deploy network account with AFT
  2. Deploy workload account with AFT

# 1. Deploy network account with AFT

network.tf consist of code for provisioning of network account which will consist of core networking resources required for setting up Transit Gateway and IPAM pool which would be shared with PROD OU and DEV OU using Resources Access Manager(RAM)

## Scope
network.tf would be responsible for provisioning the network account with SSO and also executing the terraform script placed in aft-account-customizations repository under terraform folder with naming convention of folder as "network" which is responsible for IPAM pool creation and Transit Gateways one for each environment (Dev and Prod).

## Usage
```
module "network" { 
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "rob+network@example.com" 
    AccountName               = "network" 
    ManagedOrganizationalUnit = "SharedOU (ou-d55u-2fi7cs47)" 
    SSOUserEmail              = "rob+network@example.com" 
    SSOUserFirstName          = "rob" 
    SSOUserLastName           = "martin" 
  }

  account_tags = {
    "Learn Tutorial" = "AFT"      
  }

  change_management_parameters = {     
    change_requested_by = "HashiCorp Learn"
    change_reason       = "Learn AWS Control Tower Account Factory for Terraform"
  }

  custom_fields = { 
    prd_ipam_cidr = "10.101.0.0/16"  
    dev_ipam_cidr = "10.100.0.0/16"  
  }
  
  account_customizations_name = "network" 
}

```
#### The code above will provision the following:
```
✅ network account under Organization Unit SharedOU
✅ Provision SSM parameter for setting IPAM pool CIDR using custom fields which will be used by account customization for setting  IPAM pool CIDR for each respective enviornment.
✅ Attribute Account customization with value "network" will execute code within aft-account-customizations repository required for provisioning IPAM Pool and Transit Gateways
```
### Attributes in Code
```
✅ The ManagedOrganizationalUnit attribute will have value of existing AWS Organization
✅ The account_tags attribute lets you apply tags to your account according to your business criteria
✅ The change_management_parameters attribute lets you document who issues the account request and its purposes
✅ The custom_fields attribute lets you define additional metadata for your account, which you can use in your account customizations or provisioning configuration
✅ The account_customizations_name attribute lets you specify the subdirectory in the account customizations repository the pipeline should use to modify this account, if any
```
#### Custom Fields

Using Custom Fields we will be setting up IPAM CIDR ranges for IPAM Pools for each respective environment like DEV and PROD.



# 2.Deploy an workload account with AFT

workload.tf consist of code for provisioning of required account which will consist of resources required for setting up VPC ,Subnets  ,Route Tables and attaching the VPC to Transit Gateway(TGW) shared within the respective OU's like Prod and Dev.

## Scope
workload.tf would be responsible for provisioning the account with SSO and also executing the terraform script placed in aft-account-customizations repository under terraform folder with naming convention of folder as "workload" which is responsible for VPC and Subnet creation with Transit Gateway attachment.

## Prerequisite
✅ Network account should be already in place as described in section "1.Deploy a network account with AFT".

## Usage
```
module "bu" { 
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "rob+prodbuone@example.com" 
    AccountName               = "prodbuone" 
    ManagedOrganizationalUnit = "Prod (ou-d55u-r5oq0amp)" 
    SSOUserEmail              = "rob+prodbuone@example.com" 
    SSOUserFirstName          = "rob" 
    SSOUserLastName           = "martin"
  }

  account_tags = {  #You can specify required tags for your account
    "Learn Tutorial" = "AFT"
  }

  change_management_parameters = { 
    change_requested_by = "HashiCorp Learn"
    change_reason       = "Learn AWS Control Tower Account Factory for Terraform"
  }

  custom_fields = {} 

  account_customizations_name = "workload"
}

```
#### The code above will provision the following:
```
✅ prodbuone account under Organization Unit Prod
✅ Prod OU will have Transit Gateway shared to it which will accept the Attachment once the VPC is been created.
✅ Attribute Account customization with value "workload" will execute code within aft-account-customizations repository required for provisioning VPC and Subnets with appropriate routes and TGW attachment
```
### Attributes in Code
```
✅ The ManagedOrganizationalUnit attribute will have value of existing AWS Organization
✅ The AccountName attribute lets you to define name of your account as per your requirement.
✅ The account_tags attribute lets you apply tags to your account according to your business criteria
✅ The change_management_parameters attribute lets you document who issues the account request and its purposes
✅ The custom_fields attribute lets you define additional metadata for your account, which you can use in your account customizations or provisioning configuration
✅ The account_customizations_name attribute lets you specify the subdirectory in the account customizations repository the pipeline should use to modify this account, if any
```

## Requirements

| Name          | Version       | 
| ------------- | ------------- |
| Terraform     | >= 1.0.0      | 
| AWS           | >= 4.13       | 

## Providers

| Name          | Version       | 
| ------------- | ------------- | 
| AWS           | >= 4.13       |

## Output 

This will create network account within your specified OU and you can check the account created in AWS Organization as well as you will get notification on your provided AccountEmail Id.

## Note
 
 The code has comments that will help you to define the values for each attribute



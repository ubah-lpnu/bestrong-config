variable "resource_group_name" {
    type = string
    description = "The name of the resource group in which the resources are created"
}

variable "resource_location" {
    type = string
    description = "The location/region of the resource."
}


variable "org_name" {
    type = string
    description = "The name of the organization"
}

variable "subnet_id" {
    type = string
    description = "The id of the subnet in which the private endpoint is created"
}

variable "storage_account_access_key" {
    type = string
    description = "The access key of the storage account"
}

variable "storage_account_name" {
    type = string
    description = "The name of the storage account"
}
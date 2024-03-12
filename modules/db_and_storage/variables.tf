variable "resource_group_name" {
    type = string
    description = "The name of the resource group in which the resources are created"
}

variable "resource_location" {
    type = string
    description = "The location/region of the resource."
}

variable "administrator_login" {
    type = string
    description = "The administrator login name for the SQL Server."
}

variable "administrator_login_password" {
    type = string
    description = "The administrator login password for the SQL Server."
}

variable "org_name" {
    type = string
    description = "The name of the organization"
}

variable "subnet_id" {
    type = string
    description = "The id of the subnet in which the private endpoint is created"
}
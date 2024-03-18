terraform {
  required_version = ">=1.7.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.2"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform-state"
    storage_account_name = "stbestrongeastus001"
    container_name       = "cibestrong001"
    key                  = "terraform.conf.tfstate"
  }
}

locals {
  org_name = "bestrong"
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.org_name}-rg"
  location = "East US"
}

module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.rg.name
  org_name            = local.org_name
}

module "db_and_storage" {
  source                       = "./modules/db_and_storage"
  resource_group_name          = azurerm_resource_group.rg.name
  resource_location            = azurerm_resource_group.rg.location
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  org_name                     = local.org_name
  subnet_id                    = module.network.vnet_subnet_2_id
}

module "app_service" {
  source                     = "./modules/app_service"
  resource_group_name        = azurerm_resource_group.rg.name
  resource_location          = azurerm_resource_group.rg.location
  org_name                   = local.org_name
  subnet_id                  = module.network.vnet_subnet_1_id
  storage_account_access_key = module.db_and_storage.storage_account_access_key
  storage_account_name       = module.db_and_storage.storage_account_name

  depends_on = [module.db_and_storage]
}

module "registry" {
  source              = "./modules/registry"
  resource_group_name = azurerm_resource_group.rg.name
  resource_location   = azurerm_resource_group.rg.location
  org_name            = local.org_name
  principal_id        = module.app_service.azurerm_windows_web_app_principal_id

  depends_on = [module.app_service]
}

module "key_vault" {
  source              = "./modules/key_vault"
  resource_group_name = azurerm_resource_group.rg.name
  resource_location   = azurerm_resource_group.rg.location
  org_name            = local.org_name
  principal_id        = module.app_service.azurerm_windows_web_app_principal_id
  subnet_id           = module.network.vnet_subnet_2_id

  depends_on = [module.app_service]

}



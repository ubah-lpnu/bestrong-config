
data "azurerm_client_config" "current" {}

//https://github.com/hashicorp/terraform-provider-azurerm/issues/1643
resource "azurerm_key_vault" "kv" {
  name                = "${var.org_name}-kv"
  location            = var.resource_location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  purge_protection_enabled = false
  enable_rbac_authorization = true
  soft_delete_retention_days = 7

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    virtual_network_subnet_ids = [var.subnet_id]
  
  }
}

resource "azurerm_role_assignment" "kv-webapp-ra" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id = var.principal_id

  depends_on = [ azurerm_key_vault.kv]  
}
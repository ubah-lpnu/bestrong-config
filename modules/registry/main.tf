resource "azurerm_role_assignment" "acr-webapp-ra" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id = var.principal_id

  depends_on = [ azurerm_container_registry.acr]
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.org_name}acr"
  resource_group_name = var.resource_group_name
  location            = var.resource_location
  sku                 = "Standard"
  admin_enabled       = true
}
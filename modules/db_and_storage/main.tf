resource "azurerm_mssql_server" "sql_server" {
  name                         = "${var.org_name}mssqlserver"
  resource_group_name          = var.resource_group_name
  location                     = var.resource_location
  version                      = "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
}

//https://learn.microsoft.com/en-us/azure/private-link/create-private-endpoint-terraform?tabs=azure-cli
resource "azurerm_private_endpoint" "sql_endpoint" {
  name                = "${var.org_name}-endpoint-sql"
  location            = var.resource_location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.org_name}-sql-private-connection"
    private_connection_resource_id = azurerm_mssql_server.sql_server.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}

resource "azurerm_storage_account" "storage_acc" {
  name                     = "${var.org_name}storageacc"
  resource_group_name      = var.resource_group_name
  location                 = var.resource_location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}


resource "azurerm_private_endpoint" "storage_endpoint" {
  name                = "${var.org_name}-endpoint-storage"
  location            = var.resource_location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.org_name}-storage-connection"
    private_connection_resource_id = azurerm_storage_account.storage_acc.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}





resource "azurerm_service_plan" "sp" {
  name                = "${var.org_name}-sp"
  resource_group_name = var.resource_group_name
  location            = var.resource_location
  sku_name            = "B1"
  os_type             = "Windows"
}


resource "azurerm_log_analytics_workspace" "log_workspace" {
  name                = "workspace-${var.org_name}"
  resource_group_name    = var.resource_group_name
  location               = var.resource_location
}

resource "azurerm_application_insights" "app_insights" {
  name                = "${var.org_name}-app-insights"
  location            = var.resource_location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.log_workspace.id

  depends_on = [ azurerm_log_analytics_workspace.log_workspace ]
}

resource "azurerm_windows_web_app" "webapp" {
  name                = "${var.org_name}-webapp"
  resource_group_name = var.resource_group_name
  location            = var.resource_location
  service_plan_id     = azurerm_service_plan.sp.id

  site_config {
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v8.0"
    }
    ip_restriction {
      action                    = "Allow"
      virtual_network_subnet_id = var.subnet_id
    }

  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY           = azurerm_application_insights.app_insights.instrumentation_key
    APPAPPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.app_insights.connection_string
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
  }

  depends_on = [
  azurerm_application_insights.app_insights,
  azurerm_service_plan.sp
  ]

  storage_account {
    access_key = var.storage_account_access_key
    account_name = var.storage_account_name
    name = "webappstorage"
    share_name = "webappshare"
    type = "AzureFiles"
    mount_path = "\\mounts\\${var.org_name}share"
  }

}

resource "azurerm_app_service_virtual_network_swift_connection" "webapp_vnet_con" {
  app_service_id = azurerm_windows_web_app.webapp.id
  subnet_id      = var.subnet_id
}
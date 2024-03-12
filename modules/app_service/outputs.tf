output "azurerm_service_plan" {
    value = azurerm_service_plan.sp
}


output "azurerm_windows_web_app_principal_id" {
    value = azurerm_windows_web_app.webapp.identity[0].principal_id
}
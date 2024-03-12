output "storage_account_access_key" {
    value = azurerm_storage_account.storage_acc.primary_access_key
}
output "storage_account_name" {
    value = azurerm_storage_account.storage_acc.name
}


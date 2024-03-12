output "vnet_app_id" {
  value = azurerm_virtual_network.v-net1.id
}

output "vnet_subnet_1_id" {
  value = azurerm_subnet.v-net1-subnet-web.id
}

output "vnet_subnet_2_id" {
  value = azurerm_subnet.v-net1-subnet2.id
}
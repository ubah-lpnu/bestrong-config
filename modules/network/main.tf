resource "azurerm_virtual_network" "v-net1" {
  name                = "${var.org_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "v-net1-subnet-web" {
  name                 = "${var.org_name}-web-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.v-net1.name
  address_prefixes     = ["10.0.0.0/24"]

  delegation {
    name = "delegation"

    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
      name = "Microsoft.Web/serverFarms"
    }
  }
}


resource "azurerm_subnet" "v-net1-subnet2" {
  name                 = "${var.org_name}-subnet2"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.v-net1.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints = ["Microsoft.KeyVault"]
}

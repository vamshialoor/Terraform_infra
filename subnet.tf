resource "azurerm_subnet" "snet_mysql_pssapi" {
  name                 = "snet-mysql-pssapi${var.pocaenvironment}"
  virtual_network_name = data.azurerm_virtual_network.pss-vnet.name
  resource_group_name  = data.azurerm_virtual_network.pss-vnet.resource_group_name
  address_prefixes     = var.snet_mysql_pssapi_address_space
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "snet_agw_pssapi" {
  name                 = "snet-agw-pssapi${var.pocaenvironment}"
  virtual_network_name = data.azurerm_virtual_network.pss-vnet.name
  resource_group_name  = data.azurerm_virtual_network.pss-vnet.resource_group_name
  address_prefixes     = var.snet_agw_pssapi_address_space
  service_endpoints    = ["Microsoft.KeyVault"]
}
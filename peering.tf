resource "azurerm_virtual_network_peering" "aks_vnet_to_vnet_pss" {
  name                         = "vnet-${var.app_name}-aks-${var.env_short}-to-vnet-pss-${var.pocaenvironment}"
  resource_group_name          = data.azurerm_virtual_network.aks-vnet.resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.aks-vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.pss-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "vnet-pss_to_aks_vnet" {
  name                         = "vnet-pss-${var.pocaenvironment}-to-vnet-${var.app_name}-aks-${var.env_short}"
  resource_group_name          = data.azurerm_virtual_network.aks-vnet.resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.pss-vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.aks-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# resource "azurerm_virtual_network_peering" "aks_vnet_to_vnet_lightning" {
#   name                         = "vnet-${var.app_name}-aks-${var.env_short}-to-vnet-lightning-${var.pocaenvironment}"
#   resource_group_name          = data.azurerm_virtual_network.aks-vnet.resource_group_name
#   virtual_network_name         = data.azurerm_virtual_network.aks-vnet.name
#   remote_virtual_network_id    = data.azurerm_virtual_network.lightning-vnet.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
# }

# resource "azurerm_virtual_network_peering" "vnet-lightning_to_aks_vnet" {
#   name                         = "vnet-lightning-${var.pocaenvironment}-to-vnet-${var.app_name}-aks-${var.env_short}"
#   resource_group_name          = data.azurerm_virtual_network.lightning-vnet.resource_group_name
#   virtual_network_name         = data.azurerm_virtual_network.lightning-vnet.name
#   remote_virtual_network_id    = data.azurerm_virtual_network.aks-vnet.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
# }
locals {
  backend_address_pool_name      = "${data.azurerm_virtual_network.pss-vnet.name}-beap"
  frontend_port_name             = "${data.azurerm_virtual_network.pss-vnet.name}-feport"
  frontend_ip_configuration_name = "${data.azurerm_virtual_network.pss-vnet.name}-feip"
  http_setting_name              = "${data.azurerm_virtual_network.pss-vnet.name}-be-htst"
  listener_name                  = "${data.azurerm_virtual_network.pss-vnet.name}-httplstn"
  request_routing_rule_name      = "${data.azurerm_virtual_network.pss-vnet.name}-rqrt"
  app_gateway_subnet_name        = azurerm_subnet.snet_agw_pssapi.name
}


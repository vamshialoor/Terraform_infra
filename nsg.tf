# These NSGs are standalone, we already have assigned NSG to my sql subnet during AKS deployment. 

module "optum_ips" {
  source = "git::https://github.com/dojo360/optum-ips"
}

resource "azurerm_network_security_group" "mysql_nsg" {
  name                = "nsg-snet-mysql-${var.resource_suffix}"
  resource_group_name = azurerm_resource_group.pss_rg.name
  location            = azurerm_resource_group.pss_rg.location
}

resource "azurerm_network_security_rule" "allow_vnet_inbound_nsg_mysql" {
  name                        = "vnet_inbound"
  resource_group_name         = azurerm_resource_group.pss_rg.name
  network_security_group_name = azurerm_network_security_group.mysql_nsg.name
  priority                    = 1500
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
}

resource "azurerm_network_security_rule" "deny_all_inbound_mysql" {
  name                        = "DenyAllInboundTraffic"
  priority                    = 4095
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.pss_rg.name
  network_security_group_name = azurerm_network_security_group.mysql_nsg.name
}

resource "azurerm_network_security_group" "agw_nsg" {
  name                = "nsg-snet-agw-${var.resource_suffix}"
  resource_group_name = azurerm_resource_group.pss_rg.name
  location            = azurerm_resource_group.pss_rg.location
}

resource "azurerm_network_security_rule" "allowappgatewayprobes_agw" {
  name                        = "AllowAppGatewayProbes"
  description                 = "Allow health probe requests originating at Application Gateway Manager through to service."
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "65200-65535"
  source_address_prefix       = "GatewayManager"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.pss_rg.name
  network_security_group_name = azurerm_network_security_group.agw_nsg.name
}

resource "azurerm_network_security_rule" "allow_inbound_appsvc" {
  count = var.pocaenvironment == "prod" || var.pocaenvironment == "preprod" ? 0 : length(keys(var.non_prod_ip))

  name                        = "AllowAppService${element(keys(var.non_prod_ip), count.index)}"
  priority                    = 111 + count.index
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefixes     = lookup(var.non_prod_ip, element(keys(var.non_prod_ip), count.index))
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.pss_rg.name
  network_security_group_name = azurerm_network_security_group.agw_nsg.name
}

resource "azurerm_network_security_rule" "allow_inbound_appsvc_prod" {
  count = var.pocaenvironment == "prod" || var.pocaenvironment == "preprod" ? length(keys(var.prod_ip)) : 0

  name                        = "AllowAppService${element(keys(var.prod_ip), count.index)}"
  priority                    = 111 + count.index
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefixes     = lookup(var.prod_ip, element(keys(var.prod_ip), count.index))
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.pss_rg.name
  network_security_group_name = azurerm_network_security_group.agw_nsg.name
}

resource "azurerm_network_security_rule" "optum_whitelist_agw" {
  name                        = "OptumWhitelist"
  description                 = "Allow requests originating from Optum (https://github.com/dojo360/optum-ips) through to service."
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefixes     = module.optum_ips.tower_ips
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.pss_rg.name
  network_security_group_name = azurerm_network_security_group.agw_nsg.name
}

resource "azurerm_network_security_rule" "optum_whitelist_agw_egress" {
  name                        = "OptumegressWhitelist"
  description                 = "Allow requests originating from Optum (https://github.com/dojo360/optum-ips) through to service."
  priority                    = 105
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefixes     = var.egressip
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.pss_rg.name
  network_security_group_name = azurerm_network_security_group.agw_nsg.name
}

resource "azurerm_network_security_rule" "customer_whitelist_agw" {
  count                       = length(var.customer_whitelist) != 0 ? 1 : 0
  name                        = "CustomerWhitelist"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefixes     = var.customer_whitelist
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.pss_rg.name
  network_security_group_name = azurerm_network_security_group.agw_nsg.name
}
resource "azurerm_network_security_rule" "whitehat_whitelist_agw" {
  count                       = length(var.whitehat_whitelist) != 0 ? 1 : 0
  name                        = "WhitehatWhitelist"
  description                 = "Allow requests originating from WhiteHat (https://source.whitehatsec.com/help/sentinel/whitehat-ip-ranges-snpt.html) through to service."
  priority                    = 104
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefixes     = var.whitehat_whitelist
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.pss_rg.name
  network_security_group_name = azurerm_network_security_group.agw_nsg.name
}

#resource "azurerm_network_security_rule" "AKS_Internal_agw" {
# name                        = "AKS_Internal"
# description                 = "Allow requests originating internally from Azure Kubernetes Service through to service."
# priority                    = 105
# direction                   = "Inbound"
# access                      = "Allow"
# protocol                    = "Tcp"
# source_port_range           = "*"
# destination_port_range      = "443"
# source_address_prefixes     = [data.azurerm_public_ip.aks_public_ip.ip_address]
# destination_address_prefix  = "*"
# resource_group_name         = azurerm_resource_group.pss_rg.name
# network_security_group_name = azurerm_network_security_group.agw_nsg.name
#}

resource "azurerm_network_security_rule" "allow_loadbalancer_inbound_agw" {
  name                        = "AllowAzureInboundLoadBalancer"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.pss_rg.name
  network_security_group_name = azurerm_network_security_group.agw_nsg.name
}

resource "azurerm_network_security_rule" "allow_vnet_inbound_nsg_agw" {
  name                        = "vnet_inbound"
  resource_group_name         = azurerm_resource_group.pss_rg.name
  network_security_group_name = azurerm_network_security_group.agw_nsg.name
  priority                    = 1500
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
}

resource "azurerm_network_security_rule" "deny_all_inbound_agw" {
  name                        = "DenyAllInboundTraffic"
  priority                    = 4095
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.pss_rg.name
  network_security_group_name = azurerm_network_security_group.agw_nsg.name
}

resource "azurerm_network_security_rule" "allow_apim_inbound_agw" {
  name                        = "AllowAPIMVIP"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefixes     = data.azurerm_api_management.apim.public_ip_addresses
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.pss_rg.name
  network_security_group_name = azurerm_network_security_group.agw_nsg.name
}

resource "azurerm_network_security_group" "nsg" {
  name                = "aks-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.pss_rg.name
}

resource "azurerm_subnet_network_security_group_association" "app_gateway_nsg_subnet_link" {
  subnet_id                 = azurerm_subnet.snet_agw_pssapi.id
  network_security_group_id = azurerm_network_security_group.agw_nsg.id

  depends_on = [azurerm_network_security_group.agw_nsg]
}

resource "azurerm_subnet_network_security_group_association" "mysql_nsg_subnet_link" {
  subnet_id                 = azurerm_subnet.snet_mysql_pssapi.id
  network_security_group_id = azurerm_network_security_group.mysql_nsg.id

  depends_on = [azurerm_network_security_group.mysql_nsg]
}
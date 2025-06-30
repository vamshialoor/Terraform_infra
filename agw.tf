# Public Ip
resource "azurerm_public_ip" "test" {
  name                = "pubip-agw-${var.resource_suffix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.pss_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}


resource "azurerm_application_gateway" "appgtw" {
  name                = "agw-${var.resource_suffix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.pss_rg.name

  sku {
    name     = var.app_gateway_sku
    tier     = var.app_gateway_tier
    capacity = var.app_gateway_capacity
  }

  firewall_policy_id = "${data.azurerm_subscription.current.id}/resourceGroups/rg-aks-poca-${var.env}/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/waf-${var.env}"

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.snet_agw_pssapi.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_port {
    name = "httpsPort"
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.test.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 20
  }

  ssl_policy {
    policy_type          = "Custom"
    min_protocol_version = "TLSv1_2"
    cipher_suites        = var.cipher_suites
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.pss_identity.id]
  }

  lifecycle {
    ignore_changes = [tags, backend_address_pool, backend_http_settings, frontend_ip_configuration, frontend_port, gateway_ip_configuration, http_listener, probe, redirect_configuration, request_routing_rule, url_path_map]
  }

  ssl_certificate {
    name                = var.cert_dns_names
    key_vault_secret_id = azurerm_key_vault_certificate.venafi_cert.secret_id
  }

  tags = var.tags

  #   depends_on = [data.azurerm_virtual_network.pss_vnet, azurerm_public_ip.test, azurerm_subnet_network_security_group_association.app_gateway_nsg_subnet_link, azurerm_key_vault.pss_keyvault]
}

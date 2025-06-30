data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

data "azurerm_virtual_network" "aks-vnet" {
  name                = var.aks-vnet-name
  resource_group_name = var.vnet-rg
}

data "azurerm_virtual_network" "pss-vnet" {
  name                = "vnet-pss-${var.pocaenvironment}"
  resource_group_name = var.vnet-rg
}

# data "azurerm_virtual_network" "lightning-vnet" {
#   name                = var.lightning_vnet
#   resource_group_name = var.lightning_rg
# }

data "azurerm_subnet" "snet_redis_endpoint" {
  name                 = "pvt-endpoint-snet-${var.env}"
  resource_group_name  = var.vnet-rg
  virtual_network_name = data.azurerm_virtual_network.aks-vnet.name
}

# data "azurerm_subnet" "snet_default" {
#   name                 = "default"
#   resource_group_name  = var.vnet-rg
#   virtual_network_name = data.azurerm_virtual_network.aks-vnet.name
# }

data "azurerm_virtual_network" "vm-vnet" {
  provider            = azurerm.non-prod
  name                = var.vm-vnet-name
  resource_group_name = var.vm-vnet-rg
}

data "azurerm_kubernetes_cluster" "k8s" {
  name                = var.aks-name
  resource_group_name = var.aks-rg
}

data "azurerm_mysql_flexible_server" "widget_dbserver" {
  name                = var.widget_dbserver
  resource_group_name = var.widget_resource_group
}

data "azurerm_user_assigned_identity" "aks_app_identity" {
  resource_group_name = "rg-aks-poca-${var.env_short}"
  name                = "mikspoca-${var.env_short}"
}

data "azurerm_api_management" "apim" {
  name                = var.apim_name
  resource_group_name = var.apim_rg
}

data "azurerm_redis_cache" "redis_cache" {
  name                = var.redis_name
  resource_group_name = var.apim_rg
}

data "azurerm_private_dns_zone" "redis_dns" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = var.eisl_resource_group_name
}

data "azurerm_key_vault" "kv" {
  name                = var.kv_common_name
  resource_group_name = var.rg_kv_common_name
}

data "azurerm_key_vault_secret" "venafi_secret" {
  name         = "venafi"
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_private_endpoint" "redis_private_endpoint" {
  name                = "pe-redis-${var.resource_suffix}"
  location            = var.location
  resource_group_name = var.apim_rg
  subnet_id           = data.azurerm_subnet.snet_redis_endpoint.id

  private_service_connection {
    name                           = data.azurerm_redis_cache.redis_cache.name
    private_connection_resource_id = data.azurerm_redis_cache.redis_cache.id
    is_manual_connection           = false
    subresource_names              = ["redisCache"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.redis_dns.id]
  }
}
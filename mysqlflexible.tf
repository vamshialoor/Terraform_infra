resource "azurerm_mysql_flexible_database" "mysql_pss_db" {
  charset             = "utf8mb4"
  collation           = "utf8mb4_0900_ai_ci"
  name                = "pss_native"
  resource_group_name = data.azurerm_mysql_flexible_server.widget_dbserver.resource_group_name
  server_name         = data.azurerm_mysql_flexible_server.widget_dbserver.name
}


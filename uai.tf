resource "azurerm_user_assigned_identity" "pss_identity" {
  resource_group_name = azurerm_resource_group.pss_rg.name
  location            = azurerm_resource_group.pss_rg.location
  name                = "mgd-id-${var.resource_suffix}"
}
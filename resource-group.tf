resource "azurerm_resource_group" "pss_rg" {
  name     = "rg-${var.app_name}-${var.resource_suffix}"
  location = var.location
}

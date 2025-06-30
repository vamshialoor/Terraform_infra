resource "azurerm_storage_account" "storage" {
  name                = "sa${var.app_name}pss${var.namespace}"
  resource_group_name = azurerm_resource_group.pss_rg.name
  location            = var.location
  tags                = var.tags
  account_tier        = var.account_tier
  is_hns_enabled      = true

  blob_properties {
    delete_retention_policy {
      days = 180
    }
    container_delete_retention_policy {
      days = 180
    }
  }
  account_replication_type = var.account_replication_type
  network_rules {
    default_action = "Allow"
  }
}



resource "azurerm_storage_container" "container" {
  depends_on            = [azurerm_storage_account.storage]
  count                 = length(var.containers_list)
  name                  = var.containers_list[count.index].name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = var.containers_list[count.index].access_type
}

#-------------------------------
# Storage Lifecycle Management
#-------------------------------
resource "azurerm_storage_management_policy" "lcpolicy" {
  count              = length(var.lifecycles) == 0 ? 0 : 1
  storage_account_id = azurerm_storage_account.storage.id

  dynamic "rule" {
    for_each = var.lifecycles
    iterator = rule
    content {
      name    = "rule${rule.key}"
      enabled = true
      filters {
        prefix_match = rule.value.prefix_match
        blob_types   = ["blockBlob"]
      }
      actions {
        base_blob {
          delete_after_days_since_modification_greater_than = rule.value.delete_after_days
        }
      }
    }
  }
}
resource "azurerm_key_vault" "pss_keyvault" {
  name                = lower("kv-${var.app_name}${var.resource_suffix}")
  resource_group_name = azurerm_resource_group.pss_rg.name
  location            = var.location

  sku_name = "standard"

  tenant_id = data.azurerm_client_config.current.tenant_id

  //soft_delete_enabled             = true
  purge_protection_enabled        = true
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    certificate_permissions = [
      "Create", "Delete", "Get", "List", "Update", "Import", "Purge"
    ]

    key_permissions = [
      "Create", "Delete", "Get", "List", "Update"
    ]

    secret_permissions = [
      "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
    ]

    storage_permissions = [
      "Delete", "Get", "List", "Update"
    ]
  }

  lifecycle {
    ignore_changes = [access_policy]
  }

  tags = var.tags

}

resource "azurerm_key_vault_access_policy" "aksidentity_access" {
  key_vault_id = azurerm_key_vault.pss_keyvault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_user_assigned_identity.aks_app_identity.principal_id

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Backup", "Restore", "Recover", "Purge"
  ]

  certificate_permissions = [
    "Get", "List", "Update"
  ]

  storage_permissions = []
  key_permissions = [
    "Get", "List", "Update"
  ]
}

resource "azurerm_key_vault_access_policy" "mgdidentity_access" {
  key_vault_id = azurerm_key_vault.pss_keyvault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_user_assigned_identity.pss_identity.principal_id

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Backup", "Restore", "Recover", "Purge"
  ]

  certificate_permissions = [
    "Get", "List", "Update"
  ]

  storage_permissions = []
  key_permissions = [
    "Get", "List", "Update"
  ]
}

# resource "azurerm_key_vault_secret" "random_password" {
#   depends_on = [azurerm_key_vault.pss_keyvault,
#   random_password.cert_password]

#   name         = "certrandompassword"
#   value        = random_password.cert_password.result
#   key_vault_id = azurerm_key_vault.pss_keyvault.id

# }
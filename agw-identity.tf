# this creates an identity for the app gateway ingress controller so that aks can update app gateway
resource "azurerm_role_assignment" "agic_managed_identity_operator" {
  scope                = azurerm_resource_group.pss_rg.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.pss_identity.principal_id
  depends_on           = [azurerm_user_assigned_identity.pss_identity]
}

resource "azurerm_role_assignment" "aks_managed_identity_operator_k8" {
  scope                = azurerm_user_assigned_identity.pss_identity.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = data.azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
  depends_on           = [azurerm_user_assigned_identity.pss_identity]
}
output "name" {
  value = data.azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "agic_manage_gateway" {
  scope                = azurerm_application_gateway.appgtw.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.pss_identity.principal_id
  depends_on           = [azurerm_user_assigned_identity.pss_identity]
}

resource "azurerm_role_assignment" "agic_read_resource_group" {
  scope                = azurerm_resource_group.pss_rg.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.pss_identity.principal_id
  depends_on           = [azurerm_user_assigned_identity.pss_identity]
}

# Azure Privileged Identity Management  ## MS Tracking ID: XSXC-1D8

resource "azurerm_role_assignment" "agic_vnet_network_contributor" {
  scope                = data.azurerm_virtual_network.pss-vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.pss_identity.principal_id
  depends_on           = [azurerm_user_assigned_identity.pss_identity]
}

resource "azurerm_role_assignment" "agw_network_contributor_role" {
  scope                = azurerm_resource_group.pss_rg.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.pss_identity.principal_id
  depends_on           = [azurerm_user_assigned_identity.pss_identity]
}

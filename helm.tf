
provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.k8s.kube_config.0.host
    username               = data.azurerm_kubernetes_cluster.k8s.kube_config.0.username
    password               = data.azurerm_kubernetes_cluster.k8s.kube_config.0.password
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)
  }
}

resource "helm_release" "agics" {
  #   depends_on = [helm_release.agic_crds]
  name       = "agic-${var.resource_suffix}"
  repository = "https://repo1.uhc.com/artifactory/api/helm/helm-virtual"
  chart      = "dojo360-ingress-azure"
  verify     = false
  namespace  = "kube-system"
  version    = "1.6.0" // Use this version as the latest version has encountered issues (ref: https://github.com/Azure/application-gateway-kubernetes-ingress/issues/1355)

  set {
    name  = "namespace"
    value = "kube-system"
  }

  set {
    name  = "appgw.subscriptionId"
    value = data.azurerm_subscription.current.subscription_id
  }

  set {
    name  = "appgw.resourceGroup"
    value = azurerm_resource_group.pss_rg.name
  }

  set {
    name  = "appgw.name"
    value = azurerm_application_gateway.appgtw.name
  }

  set {
    name  = "appgw.shared"
    value = "false"
  }

  set {
    name  = "appgw.usePrivateIP"
    value = "false"
  }

  set {
    name  = "kubernetes.watchNamespace"
    value = var.pss_namespace
  }

  set {
    name  = "kubernetes.ingressClassResource.name"
    value = "application-gateway-${var.pss_namespace}"
  }

  set {
    name  = "armAuth.type"
    value = "aadPodIdentity"
  }

  set {
    name  = "armAuth.identityResourceID"
    value = azurerm_user_assigned_identity.pss_identity.id
  }

  set {
    name  = "armAuth.identityClientID"
    value = azurerm_user_assigned_identity.pss_identity.client_id
  }

  set {
    name  = "rbac.enabled"
    value = "true"
  }
}

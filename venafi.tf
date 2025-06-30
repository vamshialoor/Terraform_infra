provider "venafi" {
  url          = "https://certificateservices.optum.com/vedsdk/"
  zone         = "\\VED\\Policy\\${var.venafi_policy_name}\\Certificates\\External - Multi-Domain (Comodo)"
  trust_bundle = file("optumcabundle.pem")
  access_token = data.azurerm_key_vault_secret.venafi_secret.value
}

resource "random_password" "cert_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_dns_zone" "dns" {
  count               = var.env != "prod" ? 1 : 0
  name                = var.cert_dns_names
  resource_group_name = azurerm_resource_group.pss_rg.name
}

resource "venafi_certificate" "my_certificate" {
  common_name  = var.cert_dns_names
  algorithm    = "RSA"
  rsa_bits     = "2048"
  key_password = random_password.cert_password.result
  valid_days   = 365

  san_dns = var.san_dns
}

resource "azurerm_key_vault_certificate" "venafi_cert" {
  name         = "${var.resource_suffix}-cert"
  key_vault_id = azurerm_key_vault.pss_keyvault.id

  certificate {
    contents = venafi_certificate.my_certificate.pkcs12
    password = random_password.cert_password.result
  }

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
}
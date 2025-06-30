# 1. Terraform Settings Block
terraform {
  # 1. Required Version Terraform
  required_version = ">= 1.0"
  # 2. Required Terraform Providers  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.29.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    venafi = {
      source = "Venafi/venafi"
      # version = "~> 1.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17.0"
    }    

  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id            = "e3c09177-aab1-41fd-a380-41161721482c"
  tenant_id                  = "db05faca-c82a-4b9d-b9c5-0f64b6755421"
  alias                      = "non-prod"
  skip_provider_registration = true
}

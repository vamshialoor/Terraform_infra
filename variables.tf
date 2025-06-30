variable "account_replication_type" {
  type    = string
  default = "GRS"
}

variable "account_tier" {
  type    = string
  default = "Standard"
}

variable "blob_properties" {
  default = {
    container_delete_retention_policy = {
      days = 180
    }
    delete_retention_policy = {
      days = 180
    }
  }
}

variable "location" {
  type    = string
  default = "centralus"
}

variable "app_name" {
  type        = string
  description = "This variable defines the project Name"
  default     = ""
}

variable "resource_suffix" {
  description = "This variable defines the resource suffix"
  default     = ""
}

variable "kvresource_suffix" {
  type        = string
  description = "This variable defines the resource suffix for keyvault"
  default     = ""
}

variable "namespace" {
  type    = string
  default = ""
}

variable "env_short" {
  description = "This variable defines the Application env"
  default     = ""
}

variable "env" {
  description = "This variable defines the Application env"
  default     = ""
}

variable "loc_short" {
  description = "This variable defines the location short"
  default     = ""
}

variable "mysql_admin_user_pss_dev" {
  type        = string
  description = "This variable defines the MySql Admin User"
  default     = "mySqlAdmin"
}

variable "mysql_sku_name" {
  type        = string
  description = "This variable defines the MySql SKU Name"
  default     = "GP_Standard_D2ds_v4"

}

variable "mysql_version" {
  type        = string
  description = "This variable defines the MySql Version"
  default     = "8.0.21"

}

variable "mysql_iops" {
  type        = number
  description = "This variable defines the MySql IOPS"
  default     = 500

}

variable "mysql_storage" {
  type        = number
  description = "This variable defines the MySql Storage"
  default     = 20

}

variable "mysql_default_zone" {
  type        = string
  description = "This variable defines the MySql Default Zone"
  default     = ""

}

variable "mysql_high_availability_mode" {
  type        = string
  description = "This variable defines the MySql High Availability Mode"
  default     = "SameZone"

}

variable "mysql_standby_availability_zone" {
  type        = string
  description = "This variable defines the MySql Standby Availability Zone"
  default     = "1"

}

variable "mysql_admin_user" {
  type        = string
  description = "This variable defines the MySql Admin "
  default     = "mySqlAdmin"
}

variable "mysql_geo_backup" {
  description = "Indicates whether or not to enable geo backups for mysql - prod only feature"
  default     = false
}

variable "pocaenvironment" {
  description = "This variable defines the Application env"
  default     = ""
}

variable "envnumber" {
  description = "This variable defines the Application env number"
  default     = ""
}
variable "vnet-rg" {
  description = "This variable defines the vnet rg"
  default     = ""
}

variable "aks-vnet-name" {
  description = "The name of the vnet for the AKS cluster"
  type        = string
}

variable "widget_dbserver" {
  description = "The name of the widget db server"
  type        = string
}

variable "venafi_access_token" {
  default     = ""
  type        = string
  sensitive   = true
  description = "Venafi access token"

}

variable "kv_common_name" {
  type        = string
  description = "This variable defines the KeyVault Common Name"
  default     = ""
}

variable "rg_kv_common_name" {
  type        = string
  description = "This variable defines the KeyVault Common resouece group"
  default     = ""
}

variable "widget_resource_group" {
  description = "The name of the widget db server resource group"
  type        = string
}

# variable "lightning_vnet" {
#   description = "The name of the lightning vnet"
#   type        = string
# }

# variable "lightning_rg" {
#   description = "The name of the lightning resource group"
#   type        = string
# }

variable "snet_mysql_pssapi_address_space" {
  description = "The address space of the snet mysql pssapi"
  type        = list(string)
}

variable "ip_rules" {
  description = "The list of IP rules to allow"
  type        = list(string)
  default     = []
}

variable "containers_list" {
  description = "List of containers to create and their access levels."
  type        = list(object({ name = string, access_type = string }))
  default     = []
}

variable "lifecycles" {
  description = "Configure Azure Storage firewalls and virtual networks"
  type        = list(object({ prefix_match = set(string), delete_after_days = number }))
  default     = []
}

variable "aks-rg" {
  type        = string
  description = "This variable defines the AKS Resource Group"
  default     = ""
}

variable "aks-name" {
  type        = string
  description = "This variable defines the AKS Name"
  default     = ""
}

variable "vm-vnet-name" {
  type        = string
  description = "This variable defines the VM Vnet Name"
  default     = ""
}

variable "vm-vnet-rg" {
  type        = string
  description = "This variable defines the VM Vnet Resource Group"
  default     = ""
}

variable "cert_dns_names" {
  type        = string
  description = "This variable defines the Cert DNS Names"
  default     = ""
}

variable "venafi_policy_name" {
  default     = "@POCA WIDGET"
  description = "Venafi policy name which contains the cert. i.e. \\VED\\Policy\\{venafi_policy_name}\\Certificates\\External - Multi-Domain (Comodo)"
}

variable "app_gateway_sku" {
  description = "Name of the Application Gateway SKU."
  default     = "WAF_v2" # WAF_v2 only for PROD; Standard_v2 for everywhere else
}

variable "app_gateway_tier" {
  description = "Tier of the Application Gateway SKU."
  default     = "WAF_v2" # WAF_v2 only for PROD; Standard_v2 for everywhere else
}

variable "app_gateway_capacity" {
  description = "application gateway capacity"
  type        = number
  default     = 1
}

variable "snet_agw_pssapi_address_space" {
  description = "App Gateway Subnet Address Prefixes"
  type        = list(string)
  default     = [" "]
}

variable "cipher_suites" {
  description = "Cipher Suite for the Application Gateway"
  type        = list(string)
  default     = ["TLS_RSA_WITH_AES_256_GCM_SHA384", "TLS_RSA_WITH_AES_128_GCM_SHA256", "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384", "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"]
}

variable "pss_namespace" {
  type    = string
  default = ""
}

variable "redis_name" {
  type        = string
  description = "This variable defines the Redis Name"
  default     = ""
}

variable "san_dns" {
  type        = list(string)
  description = "List of san dns names"
  default     = []
}

variable "customer_whitelist" {
  type        = list(string)
  description = "List of customer-facing IP addresses that the product will serve"
  default     = []
}

variable "whitehat_whitelist" {
  type        = list(string)
  description = "List of whitehat addresses for DAST scan"
  default     = []
}

variable "eisl_resource_group_name" {
  type = string
}

variable "egressip" {
  type        = list(string)
  description = "Egress IP for the App Gateway"
  default     = []
}

variable "apim_name" {
  description = "APIM VIP"
  type        = string
  default     = ""
}

variable "apim_rg" {
  description = "APIM VIP"
  type        = string
  default     = ""
}

variable "non_prod_ip" {
  type = map(list(string))
  default = {
    dev  = ["20.106.6.62", "20.106.6.147", "20.106.6.148", "20.106.7.37", "20.109.192.161", "20.109.192.166", "20.109.192.170", "20.109.192.173", "20.109.192.176", "20.109.192.178", "20.109.192.186", "20.109.192.192", "20.109.192.200", "20.109.192.207", "20.109.192.220", "20.109.192.222", "20.109.192.231", "20.109.192.234", "20.109.192.246", "20.109.192.249", "20.109.192.250", "20.109.193.14", "20.109.193.16", "20.109.193.18", "20.118.48.0"]
    test = ["20.84.250.148", "20.84.252.175", "20.84.250.163", "20.84.252.200", "20.84.252.246", "20.84.252.252", "20.84.253.58", "20.84.250.215", "20.84.253.77", "20.84.253.89", "20.84.251.82", "20.84.253.128", "20.84.251.120", "20.84.253.188", "20.84.251.139", "20.84.251.183", "20.84.251.211", "20.84.253.113", "20.106.4.124", "20.106.4.140", "20.106.4.162", "20.106.4.171", "20.106.5.174", "20.106.5.233", "20.40.202.29"]
    alpha = ["20.84.229.71", "20.109.234.145", "20.109.235.207",
    "20.109.235.208", "20.109.235.211", "20.109.235.214", "20.109.235.218", "20.109.234.18", "20.109.235.224", "20.109.235.229", "20.109.233.108", "20.109.235.5", "20.109.235.234", "20.109.235.243", "20.84.228.10", "20.109.235.36", "20.109.235.59", "20.109.236.23", "20.109.236.26", "20.109.236.50", "20.109.236.79", "20.236.203.183", "20.236.203.243", "20.236.204.68", "20.118.56.12"]
    bravo = ["52.143.247.142", "52.143.247.223", "52.154.168.10", "52.154.168.157", "52.154.168.185", "52.154.168.204", "20.221.102.3", "20.12.137.87", "20.12.137.172", "20.12.138.37", "20.12.138.187", "20.12.139.48", "20.12.139.69", "20.12.139.74", "20.12.139.92", "20.12.137.84", "20.12.139.96", "20.12.136.206", "20.12.136.239", "20.12.139.103", "20.12.137.235", "20.12.139.112", "20.12.139.116", "20.12.139.118", "20.12.139.120", "20.12.139.127", "20.12.139.184", "20.12.139.224", "20.12.137.245", "20.12.139.227", "20.118.48.15"]
    stage = ["40.89.248.186", "40.89.249.225", "40.89.250.33", "40.89.250.126", "40.89.251.18", "40.89.251.37", "40.89.251.79", "40.89.251.140", "40.89.253.73", "40.89.253.197", "40.89.254.209", "40.89.255.21", "40.89.255.55", "40.89.255.75", "40.89.255.87", "40.89.255.178", "52.143.248.35", "52.143.250.143", "20.106.7.33", "20.106.7.101", "20.106.7.105", "20.106.7.137", "20.106.7.145", "20.106.7.165", "20.40.202.25"]
  }
}

variable "prod_ip" {
  type = map(list(string))
  default = {
    prod    = ["20.118.8.91", "20.118.8.100", "20.118.8.141", "20.118.8.149", "20.118.8.166", "20.118.9.31", "20.118.9.39", "20.118.9.41", "20.118.9.46", "20.118.9.56", "20.118.9.58", "20.118.9.61", "20.118.9.62", "20.118.9.96", "20.118.9.121", "20.118.9.125", "20.118.9.160", "20.118.9.164", "20.118.9.167", "20.118.9.168", "20.118.9.171", "20.118.9.177", "20.118.9.178", "20.118.9.180", "20.118.48.1"]
    preprod = ["20.186.225.92", "20.186.226.179", "20.186.226.181", "20.186.227.36", "20.186.226.225", "20.186.227.43", "52.158.165.235", "52.185.104.41", "52.185.104.44", "52.185.104.62", "52.185.104.83", "52.185.104.99", "52.185.104.101", "52.185.104.104", "52.185.104.116", "52.185.104.133", "52.185.104.136", "52.185.104.169", "52.185.104.170", "52.185.104.172", "52.185.104.176", "52.185.105.2", "52.185.105.5", "52.185.105.68", "52.185.105.78", "52.185.105.100", "52.185.105.118", "52.185.105.161", "52.185.105.196", "52.185.105.221", "20.118.48.16"]

  }

}

variable "tags" {
  default = {
    "Purpose"          = "network perimeter"
    "ASKID"            = "AIDE_0074155"
    "AssignmentGroup"  = "POCA"
    "GLCode"           = "1000009329"
    "Division"         = "optum-clinical-ecdp"
    "Portfolio"        = "POCA"
    "Product"          = "PPH"
    "Component"        = "Azure Infrastructure"
    "ComponentVersion" = "1"
    "Environment"      = "non-prd"
  }
}
app_name                        = "poca"
pocaenvironment                 = "dev"
env                             = "nonprod"
env_short                       = "np"
location                        = "centralus"
namespace                       = "dev"
resource_suffix                 = "pss-dev"
aks-vnet-name                   = "vnet-poca-aks-np"
vnet-rg                         = "rg-poca-vnets-nonprod"
vm-vnet-name                    = "vnet-pocanonprod"
vm-vnet-rg                      = "rg-nonprodvm-jumpbox-vm-001"
aks-name                        = "aks-poca-np"
aks-rg                          = "rg-aks-poca-np"
mysql_default_zone              = "1"
widget_dbserver                 = "mysqlfspocawidgetdev002"
widget_resource_group           = "rg-poca-widget-dev-002"
snet_mysql_pssapi_address_space = ["172.16.0.0/27"]
snet_agw_pssapi_address_space   = ["172.16.1.0/27"]
pss_namespace                   = "poca-pss-dev"
kv_common_name                  = "CommonSecretsPOCA"
rg_kv_common_name               = "rg-aks-poca-np"
cert_dns_names                  = "pss.dev.poca-nonprod.optum.com"
egressip                        = ["52.189.111.58"]
apim_rg                         = "rg-poca-lightning-dev-001"
apim_name                       = "apimgmt-pocalightningdev"
# lightning_vnet                  = "vnet-pocalightning01"
# lightning_rg                    = "rg-poca-lightning-platform-01"
san_dns = ["pss-provider-search.pss.dev.poca-nonprod.optum.com"
, "pss-cost-microservice.pss.dev.poca-nonprod.optum.com"]
ip_rules = ["198.203.174.0/23", "149.111.0.0/16", "198.203.176.0/22", "168.183.0.0/16", "161.249.0.0/16", "198.203.180.0/23", "128.35.0.0/16"]
containers_list = [
  { name = "careestimator", access_type = "private" },
  { name = "costmicroservice", access_type = "private" },
  { name = "pidd", access_type = "private" },
  { name = "estimates", access_type = "private" },
]
redis_name               = "redis-pocalightningdev"
eisl_resource_group_name = "rg-eislapi-dev-02"

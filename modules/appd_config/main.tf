############################################################
# CREATE CONFIGMAP WITHOUT PROXY
############################################################
resource "kubernetes_config_map" "without-proxy" {
  count = var.use_proxy ? 0 : 1
  
  metadata {
    name      = "appd-config"
    namespace = var.namespace
  }

  data = {
    APP_NAME                           = var.app_name
    APPDYNAMICS_AGENT_APPLICATION_NAME = var.app_name #NodeJS
    
    BROWSERAPP_KEY       = var.appd_browserapp_key
    BROWSERAPP_BEACONURL = var.appd_browserapp_beaconurl
    
    ACCOUNT_NAME                   = var.appd_account_name
    APPD_ACCOUNT_NAME              = var.appd_account_name #Python
    APPDYNAMICS_AGENT_ACCOUNT_NAME = var.appd_account_name #NodeJS
    
    CONTROLLER_HOST                  = var.appd_controller_hostname
    APPD_CONTROLLER_HOST             = var.appd_controller_hostname #Python
    APPDYNAMICS_CONTROLLER_HOST_NAME = var.appd_controller_hostname # NodeJS
    
    CONTROLLER_PORT             = var.appd_controller_port
    APPD_CONTROLLER_PORT        = var.appd_controller_port #Python
    APPDYNAMICS_CONTROLLER_PORT = var.appd_controller_port #NodeJS
    
    ACCESS_KEY                           = var.appd_controller_key
    APPD_ACCOUNT_ACCESS_KEY              = var.appd_controller_key #Python
    APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY = var.appd_controller_key #NodeJS
    
    CONTROLLER_SSL                     = var.appd_controller_ssl
    APPD_SSL_ENABLED                   = "on" #Python
    APPDYNAMICS_CONTROLLER_SSL_ENABLED = var.appd_controller_ssl #NodeJS
  }
}


############################################################
# CREATE CONFIGMAP WITHOUT PROXY
############################################################
resource "kubernetes_config_map" "with-proxy" {
  count = var.use_proxy ? 1 : 0
  
  metadata {
    name      = "appd-config"
    namespace = var.namespace
  }

  data = {
    APP_NAME                           = var.app_name
    APPDYNAMICS_AGENT_APPLICATION_NAME = var.app_name #NodeJS
    
    BROWSERAPP_KEY       = var.appd_browserapp_key
    BROWSERAPP_BEACONURL = var.appd_browserapp_beaconurl
    
    ACCOUNT_NAME                   = var.appd_account_name
    APPD_ACCOUNT_NAME              = var.appd_account_name #Python
    APPDYNAMICS_AGENT_ACCOUNT_NAME = var.appd_account_name #NodeJS
    
    CONTROLLER_HOST                  = var.appd_controller_hostname
    APPD_CONTROLLER_HOST             = var.appd_controller_hostname #Python
    APPDYNAMICS_CONTROLLER_HOST_NAME = var.appd_controller_hostname # NodeJS
    
    CONTROLLER_PORT             = var.appd_controller_port
    APPD_CONTROLLER_PORT        = var.appd_controller_port #Python
    APPDYNAMICS_CONTROLLER_PORT = var.appd_controller_port #NodeJS
    
    ACCESS_KEY                           = var.appd_controller_key
    APPD_ACCOUNT_ACCESS_KEY              = var.appd_controller_key #Python
    APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY = var.appd_controller_key #NodeJS
    
    CONTROLLER_SSL                     = var.appd_controller_ssl
    APPD_SSL_ENABLED                   = "on" #Python
    APPDYNAMICS_CONTROLLER_SSL_ENABLED = var.appd_controller_ssl #NodeJS
    
    PROXY_HOST           = var.proxy_host
    APPD_HTTP_PROXY_HOST = var.proxy_host #Python
    
    PROXY_PORT           = var.proxy_port
    APPD_HTTP_PROXY_PORT = var.proxy_port #Python
  }
}

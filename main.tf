resource "kubernetes_namespace" "main" {
  metadata {
    name = var.namespace
  }
}


module "main_sa" {
  depends_on = [kubernetes_namespace.main]
  
  source  = "./modules/main_sa"

  namespace = var.namespace
}


module "appd_config" {
  depends_on = [kubernetes_namespace.main]
  
  source  = "./modules/appd_config"

  namespace = var.namespace
  
  app_name = var.app_name
  
  appd_browserapp_key       = var.appd_browserapp_key
  appd_browserapp_beaconurl = var.appd_browserapp_beaconurl
  
  appd_account_name        = var.appd_account_name
  appd_controller_hostname = var.appd_controller_hostname
  appd_controller_port     = var.appd_controller_port
  appd_controller_key      = var.appd_controller_key
  
  use_proxy  = var.use_proxy
  proxy_host = var.proxy_host
  proxy_port = var.proxy_port
}


module "orderfile" {
  depends_on = [module.main_sa]
  
  source  = "./modules/orderfile"

  app_name  = var.app_name
  namespace = var.namespace
}


module "test" {
  depends_on = [kubernetes_namespace.main]
  
  source  = "./modules/test"

  namespace = var.namespace
}

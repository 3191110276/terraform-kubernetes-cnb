resource "kubernetes_namespace" "main" {
  metadata {
    name = var.main_namespace
  }
}


module "main_sa" {
  depends_on = [kubernetes_namespace.main]
  
  source  = "./modules/main_sa"

  namespace = var.main_namespace
}


module "appd_config" {
  depends_on = [kubernetes_namespace.main]
  
  source  = "./modules/appd_config"

  namespace = var.main_namespace
  
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
  

module "customization" {
  depends_on = [kubernetes_namespace.main]
  
  source  = "./modules/customization"

  namespace = var.main_namespace
  
  inventorydb_service     = var.inventorydb_service
  payment_service         = var.payment_service
  extpayment_service      = var.extpayment_service
  initqueue_service       = var.initqueue_service
  orderprocessing_service = var.orderprocessing_service
  production_service      = var.production_service
  extprod_service         = var.extprod_service
  fulfilment_service      = var.fulfilment_service
}


module "orderfile" {
  depends_on = [module.main_sa, module.appd_config]
  
  source  = "./modules/orderfile"

  app_name  = var.app_name
  namespace = var.main_namespace
    
  orderfile_name = var.orderfile_name
  replicas       = var.orderfile_replicas
  cpu_request    = var.orderfile_cpu_request
  memory_request = var.orderfile_memory_request
  cpu_limit      = var.orderfile_cpu_limit
  memory_limit   = var.orderfile_memory_limit
}
    
module "order" {
  depends_on = [module.main_sa, module.appd_config, module.customization]
  
  source  = "./modules/order"

  app_name  = var.app_name
  namespace = var.main_namespace
    
  order_name     = var.order_name
  order_appd     = var.order_appd
  replicas       = var.order_replicas
  cpu_request    = var.order_cpu_request
  memory_request = var.order_memory_request
  cpu_limit      = var.order_cpu_limit
  memory_limit   = var.order_memory_limit
}


module "test" {
  depends_on = [kubernetes_namespace.main]
  
  source  = "./modules/test"

  namespace = var.main_namespace
}

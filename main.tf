resource "kubernetes_namespace" "main" {
  metadata {
    name = var.main_namespace
  }
}


resource "kubernetes_namespace" "trafficgen" {
  metadata {
    name = var.trafficgen_namespace
  }
}


module "quota" {
  depends_on = [kubernetes_namespace.main]
  
  source  = "./modules/quota"

  namespace = var.main_namespace
}


module "main_sa" {
  depends_on = [module.quota]
  
  source  = "./modules/main_sa"

  namespace = var.main_namespace
}


module "appd_config" {
  depends_on = [module.quota]
  
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
  depends_on = [module.quota]
  
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
  
  
module "ingress" {
  depends_on = [module.quota]
  
  source  = "./modules/ingress"

  app_name  = var.app_name
  namespace = var.main_namespace
  
  order_name     = var.order_name
  orderfile_name = var.orderfile_name
  adminfile_name = var.adminfile_name
  initqueue_name = var.initqueue_name
}


module "orderfile" {
  depends_on = [module.main_sa, module.appd_config, module.ingress]
  
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
    
    
module "adminfile" {
  depends_on = [module.main_sa, module.appd_config, module.ingress]
  
  source  = "./modules/adminfile"

  app_name  = var.app_name
  namespace = var.main_namespace
    
  adminfile_name = var.adminfile_name
  replicas       = var.adminfile_replicas
  cpu_request    = var.adminfile_cpu_request
  memory_request = var.adminfile_memory_request
  cpu_limit      = var.adminfile_cpu_limit
  memory_limit   = var.adminfile_memory_limit
}
    
module "order" {
  depends_on = [module.main_sa, module.appd_config, module.customization, module.ingress]
  
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
    

module "payment" {
  depends_on = [module.main_sa, module.appd_config, module.customization, module.ingress]
  
  source  = "./modules/payment"

  app_name  = var.app_name
  namespace = var.main_namespace
    
  payment_name     = var.payment_name
  payment_appd     = var.payment_appd
  replicas         = var.payment_replicas
  cpu_request      = var.payment_cpu_request
  memory_request   = var.payment_memory_request
  cpu_limit        = var.payment_cpu_limit
  memory_limit     = var.payment_memory_limit
}
    

module "trafficgen" {
  depends_on = [module.orderfile, module.order, module.payment]
  
  source  = "./modules/trafficgen"

  namespace = var.trafficgen_namespace

  trafficgen_name                = var.trafficgen_name
  trafficgen_replicas            = var.trafficgen_replicas
  trafficgen_min_random_delay    = var.trafficgen_min_random_delay
  trafficgen_max_random_delay    = var.trafficgen_max_random_delay
  trafficgen_lagspike_percentage = var.trafficgen_lagspike_percentage
  trafficgen_app_endpoint        = var.trafficgen_app_endpoint
}


module "test" {
  depends_on = [kubernetes_namespace.main]
  
  source  = "./modules/test"

  namespace = var.main_namespace
}

resource "kubernetes_namespace" "order" {
  metadata {
    name = var.order_namespace
  }
}


resource "kubernetes_namespace" "trafficgen" {
  metadata {
    name = var.trafficgen_namespace
  }
}


resource "kubernetes_namespace" "extprod" {
  metadata {
    name = var.extprod_namespace
  }
}


resource "kubernetes_namespace" "extpayment" {
  metadata {
    name = var.extpayment_namespace
  }
}


resource "kubernetes_namespace" "accounting" {
  metadata {
    name = var.accounting_namespace
  }
}


resource "kubernetes_namespace" "procurement" {
  metadata {
    name = var.procurement_namespace
  }
}


module "quota" {
  depends_on = [kubernetes_namespace.order]
  
  source  = "./modules/quota"

  namespace = var.order_namespace
}


module "main_sa" {
  depends_on = [module.quota]
  
  source  = "./modules/main_sa"

  namespace = var.order_namespace
}


module "appd_config" {
  depends_on = [module.quota]
  
  source  = "./modules/appd_config"

  namespace = var.order_namespace
  
  app_name = var.order_app_name
  
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

  namespace = var.order_namespace
  
  inventorydb_service     = "${var.inventorydb_name}-service"
  payment_service         = "${var.order_app_name}-${var.payment_name}"
  extpayment_service      = "${var.extpayment_name}.${var.extpayment_namespace}"
  initqueue_service       = "${var.order_app_name}-${var.orderqueue_name}-rabbitmq"
  orderprocessing_service = "${var.order_app_name}-${var.orderprocessing_name}"
  production_service      = "${var.order_app_name}-${var.production_name}"
  extprod_service         = "${var.extprod_name}.${var.extprod_namespace}"
  fulfilment_service      = "${var.order_app_name}-${var.fulfilment_name}"
}
  
  
module "ingress" {
  depends_on = [module.quota]
  
  source  = "./modules/ingress"

  app_name  = var.order_app_name
  namespace = var.order_namespace
  
  order_name     = var.order_name
  orderfile_name = var.orderfile_name
  adminfile_name = var.adminfile_name
  initqueue_name = var.orderqueue_name
}
  

module "orderqueue" {
  depends_on = [module.main_sa, module.appd_config, module.customization, module.ingress]
  
  source  = "./modules/orderqueue"

  app_name  = var.order_app_name
  namespace = var.order_namespace
}


module "inventorydb" {
  depends_on = [module.main_sa, module.appd_config, module.customization, module.ingress]
  
  source  = "./modules/inventorydb"

  app_name  = var.order_app_name
  namespace = var.order_namespace
    
  inventorydb_name = var.inventorydb_name
}

    
module "fulfilment" {
  depends_on = [module.inventorydb]
  
  source  = "./modules/fulfilment"

  app_name  = var.order_app_name
  namespace = var.order_namespace
    
  fulfilment_name = var.fulfilment_name
  fulfilment_appd = var.fulfilment_appd
  replicas        = var.fulfilment_replicas
  cpu_request     = var.fulfilment_cpu_request
  memory_request  = var.fulfilment_memory_request
  cpu_limit       = var.fulfilment_cpu_limit
  memory_limit    = var.fulfilment_memory_limit
}
  
  
module "extprod" {
  depends_on = [kubernetes_namespace.extprod, module.fulfilment]
  
  source  = "./modules/extprod"

  app_name  = var.order_app_name
  namespace = var.extprod_namespace
    
  extprod_name   = var.extprod_name
  replicas       = var.extprod_replicas
  cpu_request    = var.extprod_cpu_request
  memory_request = var.extprod_memory_request
  cpu_limit      = var.extprod_cpu_limit
  memory_limit   = var.extprod_memory_limit
  min_delay      = var.extprod_min_delay
  max_delay      = var.extprod_max_delay
  job_min_delay  = var.extprod_job_min_delay
  job_max_delay  = var.extprod_job_max_delay
  production_svc = "${var.order_app_name}-${var.production_name}.${var.order_namespace}"
}
  

module "production" {
  depends_on = [module.extprod]
  
  source  = "./modules/production"

  app_name  = var.order_app_name
  namespace = var.order_namespace
    
  production_name = var.production_name
  production_appd = var.production_appd
  replicas        = var.production_replicas
  cpu_request     = var.production_cpu_request
  memory_request  = var.production_memory_request
  cpu_limit       = var.production_cpu_limit
  memory_limit    = var.production_memory_limit
}

    
module "extpayment" {
  depends_on = [kubernetes_namespace.extpayment]
  
  source  = "./modules/extpayment"

  app_name  = var.order_app_name
  namespace = var.extpayment_namespace
    
  extpayment_name     = var.extpayment_name
  replicas            = var.extpayment_replicas
  cpu_request         = var.extpayment_cpu_request
  memory_request      = var.extpayment_memory_request
  cpu_limit           = var.extpayment_cpu_limit
  memory_limit        = var.extpayment_memory_limit
  min_random_delay    = var.extpayment_min_random_delay
  max_random_delay    = var.extpayment_max_random_delay
  lagspike_percentage = var.extpayment_lagspike_percentage
}
  
  
module "payment" {
  depends_on = [module.main_sa, module.appd_config, module.customization, module.extpayment]
  
  source  = "./modules/payment"

  app_name  = var.order_app_name
  namespace = var.order_namespace
    
  payment_name     = var.payment_name
  payment_appd     = var.payment_appd
  replicas         = var.payment_replicas
  cpu_request      = var.payment_cpu_request
  memory_request   = var.payment_memory_request
  cpu_limit        = var.payment_cpu_limit
  memory_limit     = var.payment_memory_limit
}
    
    
module "notification" {
  depends_on = [module.orderqueue]
  
  source  = "./modules/notification"

  app_name  = var.order_app_name
  namespace = var.order_namespace
    
  notification_name = var.notification_name
  notification_appd = var.notification_appd
  replicas          = var.notification_replicas
  cpu_request       = var.notification_cpu_request
  memory_request    = var.notification_memory_request
  cpu_limit         = var.notification_cpu_limit
  memory_limit      = var.notification_memory_limit
  
  initqueue_name = var.orderqueue_name
}
    

module "prodrequest" {
  depends_on = [module.orderqueue]
  
  source  = "./modules/prodrequest"

  app_name  = var.order_app_name
  namespace = var.order_namespace
    
  prodrequest_name  = var.prodrequest_name
  prodrequest_appd  = var.prodrequest_appd
  replicas          = var.prodrequest_replicas
  cpu_request       = var.prodrequest_cpu_request
  memory_request    = var.prodrequest_memory_request
  cpu_limit         = var.prodrequest_cpu_limit
  memory_limit      = var.prodrequest_memory_limit
  
  initqueue_name  = var.orderqueue_name
  production_name = var.production_name
}
    

module "orderprocessing" {
  depends_on = [module.notification, module.prodrequest]
  
  source  = "./modules/orderprocessing"

  app_name  = var.order_app_name
  namespace = var.order_namespace
    
  orderprocessing_name = var.orderprocessing_name
  orderprocessing_appd = var.orderprocessing_appd
  replicas             = var.orderprocessing_replicas
  cpu_request          = var.orderprocessing_cpu_request
  memory_request       = var.orderprocessing_memory_request
  cpu_limit            = var.orderprocessing_cpu_limit
  memory_limit         = var.orderprocessing_memory_limit
}
    

module "order" {
  depends_on = [module.orderprocessing, module.production, module.payment]
  
  source  = "./modules/order"

  app_name  = var.order_app_name
  namespace = var.order_namespace
    
  order_name     = var.order_name
  order_appd     = var.order_appd
  replicas       = var.order_replicas
  cpu_request    = var.order_cpu_request
  memory_request = var.order_memory_request
  cpu_limit      = var.order_cpu_limit
  memory_limit   = var.order_memory_limit
}


module "orderfile" {
  depends_on = [module.order]
  
  source  = "./modules/orderfile"

  app_name  = var.order_app_name
  namespace = var.order_namespace
    
  orderfile_name = var.orderfile_name
  replicas       = var.orderfile_replicas
  cpu_request    = var.orderfile_cpu_request
  memory_request = var.orderfile_memory_request
  cpu_limit      = var.orderfile_cpu_limit
  memory_limit   = var.orderfile_memory_limit
}
    

module "adminfile" {
  depends_on = [module.order]
  
  source  = "./modules/adminfile"

  app_name  = var.order_app_name
  namespace = var.order_namespace
    
  adminfile_name = var.adminfile_name
  replicas       = var.adminfile_replicas
  cpu_request    = var.adminfile_cpu_request
  memory_request = var.adminfile_memory_request
  cpu_limit      = var.adminfile_cpu_limit
  memory_limit   = var.adminfile_memory_limit
}
    

module "trafficgen" {
  depends_on = [kubernetes_namespace.trafficgen, module.orderfile, module.adminfile]
  
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
  depends_on = [module.trafficgen]
  
  source  = "./modules/test"

  namespace = var.order_namespace
}


module "accounting" {
  depends_on = [module.test]
  
  source  = "./modules/accounting"

  namespace = var.accounting_namespace

  clusterload_configurations = var.accounting_clusterload_configurations
}

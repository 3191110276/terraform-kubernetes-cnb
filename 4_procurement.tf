############################################################
# PROCUREMENT APPLICATION
############################################################
module "procurement_base" {
  depends_on = [kubernetes_namespace.procurement, module.accounting]
  
  source  = "./modules/procurement_base"

  namespace = var.procurement_namespace
    
  pod_quota = 100
  cpu_request_quota= "6"
  cpu_limit_quota = "6"
  memory_request_quota = "30G"
  memory_limit_quota = "30G"
  pvc_quota = 5
  storage_quota = "100G"
}
  
  
module "procurement_prediction" {
  depends_on = [module.procurement_base]
  
  source  = "./modules/procurement_prediction"

  namespace = var.procurement_namespace 
    
  procprediction_name = var.procprediction_name
  replicas            = var.procprediction_replicas
  cpu_request         = var.procprediction_cpu_request
  memory_request      = var.procprediction_memory_request
  cpu_limit           = var.procprediction_cpu_limit
  memory_limit        = var.procprediction_memory_limit
}


module "procurement_helm" {
  depends_on = [module.procurement_prediction]
  
  source  = "./modules/procurement"
}

  
module "procurement_edgeaggregator" {
  depends_on = [module.procurement_helm]
  
  source  = "./modules/procurement_edgeaggregator"

  namespace = var.procurement_namespace    
    
  procedgeagg_name  = var.procedgeagg_name
  replicas          = var.procedgeagg_replicas
  cpu_request       = var.procedgeagg_cpu_request
  memory_request    = var.procedgeagg_memory_request
  cpu_limit         = var.procedgeagg_cpu_limit
  memory_limit      = var.procedgeagg_memory_limit
}

  
module "procurement_edge" {
  depends_on = [module.procurement_edgeaggregator]
  
  source  = "./modules/procurement_edge"

  namespace = var.procurement_namespace    
    
  procedge_name  = var.procedge_name
  replicas       = var.procedge_replicas
  cpu_request    = var.procedge_cpu_request
  memory_request = var.procedge_memory_request
  cpu_limit      = var.procedge_cpu_limit
  memory_limit   = var.procedge_memory_limit
}

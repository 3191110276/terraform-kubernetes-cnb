############################################################
# PROCUREMENT APPLICATION
############################################################
module "procurement_base" {
  depends_on = [module.accounting]
  
  source  = "./modules/procurement_base"

  namespace = var.procurement_namespace
}
  

module "procurement_prediction" {
  depends_on = [module.procurement_base]
  
  source  = "./modules/procurement_prediction"

  namespace = var.procurement_namespace    
    
  procportal_name = var.procportal_name
  replicas        = var.procportal_replicas
  cpu_request     = var.procportal_cpu_request
  memory_request  = var.procportal_memory_request
  cpu_limit       = var.procportal_cpu_limit
  memory_limit    = var.procportal_memory_limit
}


module "procurement_portal" {
  depends_on = [module.procurement_prediction]
  
  source  = "./modules/procurement_portal"

  namespace = var.procurement_namespace    
    
  procprediction_name = var.procprediction_name
  replicas            = var.procprediction_replicas
  cpu_request         = var.procprediction_cpu_request
  memory_request      = var.procprediction_memory_request
  cpu_limit           = var.procprediction_cpu_limit
  memory_limit        = var.procprediction_memory_limit
}

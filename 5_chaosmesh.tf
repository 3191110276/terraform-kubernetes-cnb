############################################################
# DEPLOY CHAOS MESH
############################################################
module "chaosmesh" {
  depends_on = [module.procurement_edge]

  source  = "3191110276/chaosmesh/kubernetes"
  version = "0.1.5"
}

  
############################################################
# CREATE CHAOS MESH PROBLEMS
############################################################
module "chaosmesh_failures" {
  depends_on = [module.chaosmesh]
  
  source  = "./modules/chaosmesh_failures"
    
  order_app_name = var.order_app_name
    
  order_namespace       = var.order_namespace
  ext_namespace         = var.extpayment_namespace
  production_namespace  = var.extprod_namespace
  procurement_namespace = var.procurement_namespace
    
  extprod_name        = var.extprod_name
  extpayment_name     = var.extpayment_name
  fulfilment_name     = var.fulfilment_name
  adminfile_name      = var.adminfile_name
  procprediction_name = var.procprediction_name
  procexternal_name   = var.procexternal_name
  procedgeagg_name    = var.procedgeagg_name
    
  deploy_order       = var.deploy_order
  deploy_extprod     = var.deploy_extprod
  deploy_extpayment  = var.deploy_extpayment
  deploy_procurement = var.deploy_procurement
}

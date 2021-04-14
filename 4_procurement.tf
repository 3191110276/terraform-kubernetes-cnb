############################################################
# PROCUREMENT APPLICATION
############################################################
module "procurement_base" {
  depends_on = [module.accounting, kubernetes_namespace.procurement]
  
  source  = "./modules/procurement_base"

  namespace = var.procurement_namespace
}

module "procurement_helm" {
  depends_on = [module.procurement_base]
  
  source  = "./modules/procurement"
}

############################################################
# PROCUREMENT APPLICATION
############################################################
module "procurement_helm" {
  depends_on = [kubernetes_namespace.procurement]
  
  source  = "./modules/procurement"
}

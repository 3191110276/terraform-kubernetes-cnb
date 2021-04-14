############################################################
# PROCUREMENT APPLICATION
############################################################
module "procurement_helm" {
  depends_on = []
  
  source  = "./modules/procurement"
}

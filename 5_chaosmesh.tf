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
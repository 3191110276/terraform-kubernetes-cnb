############################################################
# ACCOUNTING APPLICATION
############################################################
module "accounting" {
  depends_on = [module.test]
  
  source  = "./modules/accounting"

  namespace = var.accounting_namespace

  clusterload_configurations = var.accounting_clusterload_configurations
}

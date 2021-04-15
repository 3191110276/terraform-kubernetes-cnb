############################################################
# ACCOUNTING APPLICATION
############################################################
module "accounting" {
  depends_on = [kubernetes_namespace.test, module.test]
  
  source  = "./modules/accounting"

  namespace = var.accounting_namespace

  clusterload_configurations = var.accounting_clusterload_configurations
}

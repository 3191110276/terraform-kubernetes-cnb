############################################################
# ACCOUNTING APPLICATION
############################################################
module "accounting" {
  depends_on = [kubernetes_namespace.accounting, module.test]
  
  source  = "./modules/accounting"

  namespace = var.accounting_namespace

  clusterload_configurations = var.accounting_clusterload_configurations
}

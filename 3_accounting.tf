############################################################
# ACCOUNTING APPLICATION
############################################################
module "accounting" {
  depends_on = [kubernetes_namespace.accounting, module.test]
    
  count = var.deploy_accounting ? 1 : 0
  
  source  = "./modules/accounting"

  namespace = var.accounting_namespace

  clusterload_configurations = var.accounting_clusterload_configurations
}

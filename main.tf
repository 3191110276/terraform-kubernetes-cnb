resource "kubernetes_namespace" "main" {
  metadata {
    name = var.namespace
  }
}


module "orderfile" {
  depends_on = [kubernetes_namespace.main]
  
  source  = "./modules/orderfile"

  app_name  = var.app_name
  namespace = var.namespace
}


module "test" {
  depends_on = [kubernetes_namespace.main]
  
  source  = "./modules/test"

  namespace = var.namespace
}

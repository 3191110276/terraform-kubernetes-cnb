

resource "kubernetes_namespace" "main" {
  metadata {
    name = var.namespace
  }
}


module "orderfile" {
  source  = "./modules/orderfile"

  app_name  = var.app_name
  namespace = var.namespace
}

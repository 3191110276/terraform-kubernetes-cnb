############################################################
# REQUIRED PROVIDERS
############################################################
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.2"
    }
  }
}


############################################################
# CREATE CHAOSMESH PROBLEMS
############################################################
resource "helm_release" "chaosmesh_problems_order" {  
  name       = "chaosmesh_problems_order"

  chart      = "${path.module}/helm_order/"

  namespace  = var.order_namespace
  
  set {
    name  = "app_name"
    value = var.order_app_name
  }
}

resource "helm_release" "chaosmesh_problems_ext" {  
  name       = "chaosmesh_problems_ext"

  chart      = "${path.module}/helm_ext/"

  namespace  = var.ext_namespace
}

resource "helm_release" "chaosmesh_problems_production" {  
  name       = "chaosmesh_problems_production"

  chart      = "${path.module}/helm_production/"

  namespace  = var.production_namespace
  
  set {
    name  = "extprod_name"
    value = var.extprod_name
  }
}

resource "helm_release" "chaosmesh_problems_procurement" {  
  name       = "chaosmesh_problems_procurement"

  chart      = "${path.module}/helm_procurement/"

  namespace  = var.procurement_namespace
}

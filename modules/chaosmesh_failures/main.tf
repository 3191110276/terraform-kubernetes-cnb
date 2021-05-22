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
  name       = "orderchaos"
  
  count      = var.deploy_order ? 1 : 0

  chart      = "${path.module}/helm_order/"

  namespace  = var.order_namespace
  
  set {
    name  = "app_name"
    value = var.order_app_name
  }
  
  set {
    name  = "fulfilment_name"
    value = var.fulfilment_name
  }
  
  set {
    name  = "adminfile_name"
    value = var.adminfile_name
  }
}

resource "helm_release" "chaosmesh_problems_ext" {  
  name       = "extchaos"
  
  count      = var.deploy_extpayment ? 1 : 0

  chart      = "${path.module}/helm_ext/"

  namespace  = var.ext_namespace
  
  set {
    name  = "extpayment_name"
    value = var.extpayment_name
  }
}

resource "helm_release" "chaosmesh_problems_production" {  
  name       = "productionchaos"
  
  count      = var.deploy_extprod ? 1 : 0

  chart      = "${path.module}/helm_production/"

  namespace  = var.production_namespace
  
  set {
    name  = "extprod_name"
    value = var.extprod_name
  }
}

resource "helm_release" "chaosmesh_problems_procurement" {  
  name       = "procurementchaos"
  
  count      = var.deploy_procurement ? 1 : 0

  chart      = "${path.module}/helm_procurement/"

  namespace  = var.procurement_namespace
  
  set {
    name  = "procprediction_name"
    value = var.procprediction_name
  }
  
  set {
    name  = "procexternal_name"
    value = var.procexternal_name
  }
  
  set {
    name  = "procedgeagg_name"
    value = var.procedgeagg_name
  }
}

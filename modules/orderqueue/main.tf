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
# CREATE ORDERQUEUE DEPLOYMENT
############################################################
resource "helm_release" "orderqueue" {  
  name       = "orderqueue"

  chart      = "${path.module}/helm/"

  namespace  = var.namespace
  
  set {
    name  = "appname"
    value = var.app_name
  }

  set {
    name  = "initqueue_name"
    value = var.initqueue_name
  }
}

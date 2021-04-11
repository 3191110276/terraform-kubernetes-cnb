############################################################
# REQUIRED PROVIDERS
############################################################
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
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
    name  = "orderqueue_name"
    value = var.orderqueue_name
  }
  
  set {
    name  = "registry"
    value = var.registry
  }
  
  set {
    name  = "orderqueue_tech"
    value = var.inventorydb_tech
  }
  
  set {
    name  = "orderqueue_version"
    value = var.inventorydb_version
  }
}

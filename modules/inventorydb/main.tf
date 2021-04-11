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
# CREATE INVENTORYDB
############################################################
resource "helm_release" "inventorydb" {  
  name       = "inventorydb"

  chart      = "${path.module}/helm/"

  namespace  = var.namespace

  set {
    name  = "inventorydb_name"
    value = var.inventorydb_name
  }
  
  set {
    name  = "registry"
    value = var.registry
  }
  
  set {
    name  = "inventorydb_tech"
    value = var.inventorydb_tech
  }
  
  set {
    name  = "inventorydb_version"
    value = var.inventorydb_version
  }
}

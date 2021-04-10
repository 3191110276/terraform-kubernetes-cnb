############################################################
# REQUIRED PROVIDERS
############################################################
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
    }
    kubernetes-alpha = {
      source  = "hashicorp/kubernetes-alpha"
      version = ">= 0.3.2"
    }
  }
}


############################################################
# CREATE INVENTORYDB
############################################################


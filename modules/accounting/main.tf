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
# CREATE ACCOUNTING DEPLOYMENT
############################################################
module "clusterload" {
  source  = "3191110276/clusterload/kubernetes"
  version = "0.2.1"

  namespace = var.namespace

  clusterload_configurations = var.clusterload_configurations
}

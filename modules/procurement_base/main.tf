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
# CREATE PROCUREMENT BASIC OBJECTS
############################################################
resource "kubernetes_service_account" "appdynamics-cluster-agent" {
  metadata {
    name      = "appdynamics-cluster-agent"
    namespace = var.namespace
  }
}

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

resource "kubernetes_resource_quota" "procurement" {
  metadata {
    name      = "terraform-example"
    namespace = var.namespace
  }
  spec {
    hard = {
      pods = var.pod_quota
      "requests.cpu" = "6"
      "limits.cpu" = "6"
      "requests.memory" = "30G"
      "limits.memory" = "30G"
      "persistentvolumeclaims" = 5
      "requests.storage" = "100G"
    }
  }
}

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
    name      = "${var.app_name}-quota"
    namespace = var.namespace
  }
  spec {
    hard = {
      "pods"                   = var.pod_quota
      "requests.cpu"           = var.cpu_request_quota
      "limits.cpu"             = var.cpu_limit_quota
      "requests.memory"        = var.memory_request_quota
      "limits.memory"          = var.memory_limit_quota
      "persistentvolumeclaims" = var.pvc_quota
      "requests.storage"       = var.storage_quota
    }
  }
}

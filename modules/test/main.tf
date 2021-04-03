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
# CREATE TEST POD
############################################################
resource "kubernetes_pod" "test" {
  metadata {
    name      = "test"
    namespace = var.namespace
  }

  spec {
    container {
      name  = "test"
      image = "busybox"
      
      command = ["sleep", "9999999999d"]
      
      resources {
        requests = {
          cpu    = "10m"
          memory = "8Mi"
        }
        limits = {
          cpu    = "50m"
          memory = "32Mi"
        }
      }
    }

    restart_policy = "Always"
    dns_policy     = "ClusterFirst"
  }
}

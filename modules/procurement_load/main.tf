
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
# CREATE PROCUREMENT LOAD DEPLOYMENT
############################################################
resource "kubernetes_deployment" "load" {
  timeouts {
    create = "3600s"
  }
  
  metadata {
    name      = var.procload_name
    namespace = var.namespace
  }

  spec {
    replicas = var.replicas
    
    progress_deadline_seconds = 3600

    selector {
      match_labels = {
        name  = var.procload_name
      }
    }

    template {
      metadata {
        labels = {
          name  = var.procload_name
        }
      }

      spec {
        service_account_name = "appdynamics-cluster-agent"
        
        container {
          name  = var.procload_name
          
          image = "sashaz/app-load:v1"
          
          port {
            container_port = 8080
          }

          resources {
            requests = {
              cpu    = var.cpu_request
              memory = var.memory_request
            }
            limits = {
              cpu    = var.cpu_limit
              memory = var.memory_limit
            }
          }
        }
      }
    }
  }
}

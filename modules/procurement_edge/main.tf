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
# CREATE PROCUREMENT EDGE DEPLOYMENT
############################################################
resource "kubernetes_service" "edge" {
  metadata {
    name      = "client-api"
    namespace = var.namespace
  }
  spec {
    type = "ClusterIP"
    
    selector = {
      name  = var.procedge_name
    }
    
    port {
      name        = "8080"
      port        = 8080
      target_port = 8080
    }
  }
}


resource "kubernetes_deployment" "edge" {
  wait_for_completion = true
  timeouts {
    create = "900s"
  }
  
  metadata {
    name      = var.procedge_name
    namespace = var.namespace
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        name  = var.procedge_name
      }
    }

    template {
      metadata {
        labels = {
          name  = var.procedge_name
        }
      }

      spec {
        service_account_name = "appdynamics-cluster-agent"
        
        container {
          name  = var.procedge_name
          
          image = "sashaz/java-services:v5"
          
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

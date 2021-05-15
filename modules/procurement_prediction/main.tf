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
# CREATE PROCUREMENT PREDICTION DEPLOYMENT
############################################################
resource "kubernetes_service" "prediction" {
  metadata {
    name      = "world-generator"
    namespace = var.namespace
  }
  spec {
    type = "ClusterIP"
    
    selector = {
      name  = var.procprediction_name
    }
    
    port {
      name        = "8080"
      port        = 8080
      target_port = 8080
    }
  }
}


resource "kubernetes_deployment" "prediction" {
  timeouts {
    create = "3600s"
  }
  
  metadata {
    name      = var.procprediction_name
    namespace = var.namespace
  }

  spec {
    replicas = var.replicas
    
    progress_deadline_seconds = 3600

    selector {
      match_labels = {
        name  = var.procprediction_name
      }
    }

    template {
      metadata {
        labels = {
          name  = var.procprediction_name
        }
      }

      spec {
        service_account_name = "appdynamics-cluster-agent"
        
        container {
          name  = var.procprediction_name
          
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

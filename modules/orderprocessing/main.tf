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
# CREATE ORDERPROCESSING DEPLOYMENT
############################################################
resource "kubernetes_service" "orderprocessing" {
  metadata {
    name      = "${var.app_name}-${var.orderprocessing_name}"
    namespace = var.namespace
    
    labels = {
      app  = var.app_name
      tier = var.orderprocessing_name
    }
  }
  spec {
    type = "ClusterIP"
    
    selector = {
      app  = var.app_name
      tier = var.orderprocessing_name
    }
    
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }
  }
}


resource "kubernetes_deployment" "orderprocessing" {
  metadata {
    name      = var.orderprocessing_name
    namespace = var.namespace
    
    labels = {
      app  = var.app_name
      tier = var.orderprocessing_name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app  = var.app_name
        tier = var.orderprocessing_name
      }
    }

    template {
      metadata {
        labels = {
          app  = var.app_name
          tier = var.orderprocessing_name
        }
      }

      spec {
        service_account_name            = "no-priv"
        automount_service_account_token = false
        
        container {
          name  = var.order_name
          
          image = "${var.registry}/orderprocessing-${var.orderprocessing_tech}:${var.orderprocessing_version}"
          
          port {
            name           = "http"
            protocol       = "TCP"
            container_port = 80
          }
          
          env {
            name  = "APPD_APP_NAME"
            value = var.app_name
          }
          
          env {
            name  = "APPD_TIER_NAME"
            value = var.orderprocessing_appd
          }
          
          env_from {
            config_map_ref {
              name = "appd-config"
            }
          }
          
          volume_mount {
            name       = "customization"
            mount_path = "/etc/customization"
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
        
        volume {
          name = "customization"
          config_map {
            name = "customization"
          }
        }
      }
    }
  }
}

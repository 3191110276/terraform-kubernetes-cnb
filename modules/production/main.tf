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
# CREATE PRODUCTION DEPLOYMENT
############################################################
resource "kubernetes_service" "production" {
  metadata {
    name      = var.production_name
    namespace = var.namespace
    
    labels = {
      app  = var.app_name
      tier = var.production_name
    }
  }
  spec {
    type = "ClusterIP"
    
    selector = {
      app  = var.app_name
      tier = var.production_name
    }
    
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }
  }
}


resource "kubernetes_deployment" "production" {
  timeouts {
    create = "1800s"
  }
  
  metadata {
    name      = var.production_name
    namespace = var.namespace
    
    labels = {
      app  = var.app_name
      tier = var.production_name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app  = var.app_name
        tier = var.production_name
      }
    }

    template {
      metadata {
        labels = {
          app  = var.app_name
          tier = var.production_name
        }
      }

      spec {
        service_account_name            = "no-priv"
        automount_service_account_token = false
        
        container {
          name  = var.production_name
          
          image = "${var.registry}/production-${var.production_tech}:${var.production_version}"
          
          port {
            name           = "http"
            protocol       = "TCP"
            container_port = 80
          }
          
          port {
            name           = "https"
            protocol       = "TCP"
            container_port = 443
          }
          
          env {
            name  = "APPD_APP_NAME"
            value = var.app_name
          }
          
          env {
            name  = "APPD_TIER_NAME"
            value = var.production_appd
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
          
          startup_probe {
            http_get {
              path = "/healthz"
              port = 80
            }

            period_seconds    = 5
            failure_threshold = 40
          }
          
          liveness_probe {
            http_get {
              path = "/healthz"
              port = 80
            }

            initial_delay_seconds = 5
            period_seconds        = 2
            failure_threshold     = 4
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

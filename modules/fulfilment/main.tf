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
# CREATE FULFILMENT DEPLOYMENT
############################################################
resource "kubernetes_service" "fulfilment" {
  metadata {
    name      = var.fulfilment_name
    namespace = var.namespace
    
    labels = {
      app  = var.app_name
      tier = var.fulfilment_name
    }
  }
  spec {
    type = "ClusterIP"
    
    selector = {
      app  = var.app_name
      tier = var.fulfilment_name
    }
    
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }
  }
}


resource "kubernetes_deployment" "fulfilment" {
  timeouts {
    create = "900s"
  }
  
  metadata {
    name      = var.fulfilment_name
    namespace = var.namespace
    
    labels = {
      app  = var.app_name
      tier = var.fulfilment_name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app  = var.app_name
        tier = var.fulfilment_name
      }
    }

    template {
      metadata {
        labels = {
          app  = var.app_name
          tier = var.fulfilment_name
        }
      }

      spec {
        service_account_name            = "no-priv"
        automount_service_account_token = false
        
        container {
          name  = var.fulfilment_name
          
          image = "${var.registry}/fulfilment-${var.fulfilment_tech}:${var.fulfilment_version}"
          
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
            value = var.fulfilment_appd
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

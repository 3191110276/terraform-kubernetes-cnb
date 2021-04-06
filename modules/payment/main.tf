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
# CREATE ORDER DEPLOYMENT
############################################################
resource "kubernetes_service" "payment" {
  metadata {
    name      = "${var.app_name}-${var.payment_name}"
    namespace = var.namespace
    
    labels = {
      app  = var.app_name
      tier = var.payment_name
    }
  }
  spec {
    type = "ClusterIP"
    
    selector = {
      app  = var.app_name
      tier = var.payment_name
    }
    
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }
    port {
      name        = "https"
      protocol    = "TCP"
      port        = 443
      target_port = 443
    }
  }
}


resource "kubernetes_deployment" "payment" {
  metadata {
    name      = var.payment_name
    namespace = var.namespace
    
    labels = {
      app  = var.app_name
      tier = var.payment_name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app  = var.app_name
        tier = var.payment_name
      }
    }

    template {
      metadata {
        labels = {
          app  = var.app_name
          tier = var.payment_name
        }
      }

      spec {
        service_account_name            = "no-priv"
        automount_service_account_token = false
        
        container {
          name  = var.payment_name
          
          image = "${var.registry}/order-${var.payment_tech}:${var.payment_version}"
          
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
            value = var.payment_appd
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

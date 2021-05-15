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
# CREATE EXTPAYMENT
############################################################
resource "kubernetes_config_map" "extpayment" {
  metadata {
    name      = "customization"
    namespace = var.namespace
  }

  data = {
    MIN_RANDOM_DELAY    = var.min_random_delay
    MAX_RANDOM_DELAY    = var.max_random_delay
    LAGSPIKE_PERCENTAGE = var.lagspike_percentage
  }
}


resource "kubernetes_service_account" "extpayment" {
  metadata {
    name      = "no-priv"
    namespace = var.namespace
  }
  
  automount_service_account_token = false
}


resource "kubernetes_service" "extpayment" {
  metadata {
    name      = var.extpayment_name
    namespace = var.namespace
    
    labels = {
      tier = var.extpayment_name
    }
  }
  spec {
    type = "ClusterIP"
    
    selector = {
      tier = var.extpayment_name
    }
    
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = 5000
    }
  }
}


resource "kubernetes_deployment" "extpayment" {
  timeouts {
    create = "3600s"
  }
  
  metadata {
    name      = var.extpayment_name
    namespace = var.namespace
    
    labels = {
      tier = var.extpayment_name
    }
  }

  spec {
    replicas = var.replicas
    
    progress_deadline_seconds = 3600

    selector {
      match_labels = {
        tier = var.extpayment_name
      }
    }

    template {
      metadata {
        labels = {
          tier = var.extpayment_name
        }
      }

      spec {
        service_account_name = "no-priv"
        
        container {
          name  = var.extpayment_name
          
          image = "${var.registry}/extpayment-${var.extpayment_tech}:${var.extpayment_version}"
          
          port {
            name           = "http"
            protocol       = "TCP"
            container_port = 5000
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
              port = 5000
            }

            period_seconds    = 5
            failure_threshold = 40
          }
          
          liveness_probe {
            http_get {
              path = "/healthz"
              port = 5000
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

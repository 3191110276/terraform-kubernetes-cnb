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
# CREATE ADMINFILE DEPLOYMENT
############################################################
resource "kubernetes_service" "orderfile" {
  metadata {
    name      = var.adminfile_name
    namespace = var.namespace
    
    labels = {
      app  = var.app_name
      tier = var.adminfile_name
    }
  }
  spec {
    type = "ClusterIP"
    
    selector = {
      app  = var.app_name
      tier = var.adminfile_name
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


resource "kubernetes_deployment" "orderfile" {
  metadata {
    name      = var.adminfile_name
    namespace = var.namespace
    
    labels = {
      app  = var.app_name
      tier = var.adminfile_name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app  = var.app_name
        tier = var.adminfile_name
      }
    }

    template {
      metadata {
        labels = {
          app  = var.app_name
          tier = var.adminfile_name
        }
      }

      spec {
        service_account_name            = "no-priv"
        automount_service_account_token = false
        
        container {
          name  = "fileserver"
          
          image = "${var.registry}/adminfile-${var.adminfile_tech}:${var.adminfile_version}"
          
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
          
          env_from {
            config_map_ref {
              name = "appd-config"
            }
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

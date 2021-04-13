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
# CREATE PRODREQUEST DEPLOYMENT
############################################################
resource "kubernetes_service" "prodrequest" {
  metadata {
    name      = "${var.prodrequest_name}"
    namespace = var.namespace
    
    labels = {
      app  = var.app_name
      tier = var.prodrequest_name
    }
  }
  spec {
    type = "ClusterIP"
    
    selector = {
      app  = var.app_name
      tier = var.prodrequest_name
    }
    
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }
  }
}


resource "kubernetes_deployment" "prodrequest" {
  metadata {
    name      = var.prodrequest_name
    namespace = var.namespace
    
    labels = {
      app  = var.app_name
      tier = var.prodrequest_name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app  = var.app_name
        tier = var.prodrequest_name
      }
    }

    template {
      metadata {
        labels = {
          app  = var.app_name
          tier = var.prodrequest_name
        }
      }

      spec {        
        container {
          name  = var.prodrequest_name
          
          image = "${var.registry}/prodrequest-${var.prodrequest_tech}:${var.prodrequest_version}"
          
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
            value = var.prodrequest_appd
          }
          
          env {
            name  = "APPDYNAMICS_NETVIZ_AGENT_HOST"
            value_from {
              field_ref {
                field_path = "status.hostIP"
              }
            }
          }
          
          env {
            name  = "APPDYNAMICS_NETVIZ_AGENT_PORT"
            value = "3892"
          }
          
          env {
            name  = "INITQUEUE_SVC"
            value = "${var.initqueue_name}-rabbitmq"
          }
          
          env {
            name  = "PRODUCTION_SVC"
            value = "${var.production_name}"
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

resource "kubernetes_service" "orderfile" {
  metadata {
    name      = "${var.app_name}-${var.orderfile_name}"
    namespace = var.namespace
    
    labels = {
      app  = var.app_name
      tier = var.orderfile_name
    }
  }
  spec {
    type = "ClusterIP"
    
    selector = {
      app  = var.app_name
      tier = var.orderfile_name
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
    name      = var.orderfile_name
    namespace = var.namespace
    
    labels = {
      app  = var.app_name
      tier = var.orderfile_name
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app  = var.app_name
        tier = var.orderfile_name
      }
    }

    template {
      metadata {
        labels = {
          app  = var.app_name
          tier = var.orderfile_name
        }
      }

      spec {
        service_account_name            = "no-priv"
        automount_service_account_token = false
        
        container {
          name  = "fileserver"
          
          image = {{ .Values.registry }}/orderfile-{{ .Values.orderfile_tech }}:{{ .Values.orderfile_version }}
          
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
              cpu    = "20m"
              memory = "32Mi"
            }
            limits = {
              cpu    = "50m"
              memory = "32Mi"
            }

          }
        }
      }
    }
  }
}

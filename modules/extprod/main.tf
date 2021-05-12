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
# CREATE EXTPROD
############################################################
resource "kubernetes_config_map" "extprod" {
  metadata {
    name      = "customization"
    namespace = var.namespace
  }

  data = {
    MIN_RANDOM     = var.min_delay
    MAX_RANDOM     = var.max_delay
    JOB_MIN        = var.job_min_delay
    JOB_MAX        = var.job_max_delay
    PRODUCTION_SVC = var.production_svc
    NAMESPACE      = var.namespace
  }
}


resource "kubernetes_service_account" "extprod" {
  metadata {
    name      = "factory"
    namespace = var.namespace
  }
}


resource "kubernetes_role" "extprod" {
  metadata {
    name      = "factory"
    namespace = var.namespace
  }

  rule {
    api_groups     = [""]
    resources      = ["pods"]
    verbs          = ["get", "list", "delete"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs"]
    verbs      = ["get", "list", "create", "delete"]
  }
}


resource "kubernetes_role_binding" "extprod" {
  depends_on = [kubernetes_service_account.extprod, kubernetes_role.extprod]
  
  metadata {
    name      = "factory"
    namespace = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "factory"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "factory"
    namespace = var.namespace
  }
}


resource "kubernetes_service" "extprod" {
  metadata {
    name      = var.extprod_name
    namespace = var.namespace
    
    labels = {
      tier = var.extprod_name
    }
  }
  spec {
    type = "ClusterIP"
    
    selector = {
      tier = var.extprod_name
    }
    
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }
  }
}


resource "kubernetes_deployment" "extprod" {
  wait_for_completion = true
  timeouts {
    create = "900s"
  }
  
  metadata {
    name      = var.extprod_name
    namespace = var.namespace
    
    labels = {
      tier = var.extprod_name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        tier = var.extprod_name
      }
    }

    template {
      metadata {
        labels = {
          tier = var.extprod_name
        }
      }

      spec {
        service_account_name = "factory"
        
        container {
          name  = var.extprod_name
          
          image = "${var.registry}/extprod-${var.extprod_tech}:${var.extprod_version}"
          
          port {
            name           = "http"
            protocol       = "TCP"
            container_port = 80
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

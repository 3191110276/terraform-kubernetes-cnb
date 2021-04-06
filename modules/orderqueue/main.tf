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
# CREATE ORDERQUEUE DEPLOYMENT
############################################################
resource "kubernetes_service" "orderqueue_headless" {
  metadata {
    name = "${var.app_name}-${var.initqueue_name}-rabbitmq-headless"
    namespace = var.namespace
  }
  spec {
    selector = {
      tier = var.oderqueue_name
    }
    port {
      name        = "epmd"
      port        = 4369
      target_port = "epmd"
    }

    port {
      name        = "amqp"
      port        = 5672
      target_port = "amqp"
    }

    port {
      name        = "dist"
      port        = 25672
      target_port = "dist"
    }

    port {
      name        = "http-stats"
      port        = 15672
      target_port = "http-stats"
    }

    type = "ClusterIP"
    cluster_ip = "None"
  }
}


resource "kubernetes_service" "orderqueue" {
  metadata {
    name = "${var.app_name}-${var.initqueue_name}-rabbitmq"
    namespace = var.namespace
  }
  spec {
    selector = {
      tier = var.oderqueue_name
    }
    port {
      name        = "epmd"
      port        = 4369
      target_port = "epmd"
    }

    port {
      name        = "amqp"
      port        = 5672
      target_port = "amqp"
    }

    port {
      name        = "dist"
      port        = 25672
      target_port = "dist"
    }

    port {
      name        = "http-stats"
      port        = 15672
      target_port = "http-stats"
    }

    type = "ClusterIP"
  }
}









resource "kubernetes_stateful_set" "orderqueue" {
  depends_on = [kubernetes_service.orderqueue_headless, kubernetes_service.orderqueue, kubernetes_pod_disruption_budget.orderqueue, kubernetes_secret.orderqueue, kubernetes_role_binding.orderqueue, kubernetes_config_map.orderqueue]
  
  metadata {
    name      = "${var.app_name}-${var.initqueue_name}-rabbitmq"
    namespace = var.namespace
  }

  spec {
    pod_management_policy  = "OrderedReady"
    replicas               = 3
    
    update_strategy {
      type = "RollingUpdate"
    }

    selector {
      match_labels = {
        tier = var.initqueue_name
      }
    }

    service_name = "${var.app_name}-${var.initqueue_name}-rabbitmq-headless"

    template {
      metadata {
        labels = {
          tier = var.initqueue_name
        }
        
        annotations = {
          "checksum/config" = "0a4e272ea944acede38be298ecdf4ce8b4a2b83f32c2015e815c4ee1d4c78162"
          "checksum/secret" = "cdf4233d6b9f1dab011c2fd778cf07f09c0565cdf595f41c2ddb275baad49e5c"
        }
      }

      spec {
        service_account_name = "${var.app_name}-${var.initqueue_name}-rabbitmq"
        
        termination_grace_period_seconds = 120

        
        
        
        
        
        container {
          name              = "prometheus-server"
          image             = "prom/prometheus:v2.2.1"
          image_pull_policy = "IfNotPresent"

          args = [
            "--config.file=/etc/config/prometheus.yml",
            "--storage.tsdb.path=/data",
            "--web.console.libraries=/etc/prometheus/console_libraries",
            "--web.console.templates=/etc/prometheus/consoles",
            "--web.enable-lifecycle",
          ]

          port {
            container_port = 9090
          }

          resources {
            limits = {
              cpu    = "200m"
              memory = "1000Mi"
            }

            requests = {
              cpu    = "200m"
              memory = "1000Mi"
            }
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/etc/config"
          }

          volume_mount {
            name       = "prometheus-data"
            mount_path = "/data"
            sub_path   = ""
          }

          readiness_probe {
            http_get {
              path = "/-/ready"
              port = 9090
            }

            initial_delay_seconds = 30
            timeout_seconds       = 30
          }

          liveness_probe {
            http_get {
              path   = "/-/healthy"
              port   = 9090
              scheme = "HTTPS"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 30
          }
        }

        volume {
          name = "config-volume"

          config_map {
            name = "prometheus-config"
          }
        }
      }
    }

    
    
    
    
    
    volume_claim_template {
      metadata {
        name = "data"
        
        labels = {
          "app.kubernetes.io/name" = "rabbitmq"
          "app.kubernetes.io/instance" = "${var.app_name}-${var.initqueue_name}"
        }
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "8Gi"
          }
        }
      }
    }
  }
}
























resource "kubernetes_pod_disruption_budget" "orderqueue" {
  metadata {
    name      = "${var.app_name}-${var.initqueue_name}-rabbitmq"
    namespace = var.namespace
  }
  spec {
    min_available = "1"
    selector {
      match_labels = {
        test = var.initqueue_name
      }
    }
  }
}


resource "kubernetes_secret" "orderqueue" {
  metadata {
    name      = "${var.app_name}-${var.initqueue_name}-rabbitmq"
    namespace = var.namespace
  }

  data = {
    "rabbitmq-password" = "Z3Vlc3QK"
    "rabbitmq-erlang-cookie" = "OWU2SE1ZMTRwa2NMTVZIQjhiUnlmNzFPempwSnBRSDE="
  }

  type = "Opqaue"
}


resource "kubernetes_service_account" "orderqueue" {
  depends_on = [kubernetes_secret.orderqueue]
  
  metadata {
    name      = "${var.app_name}-${var.initqueue_name}-rabbitmq"
    namespace = var.namespace
  }
  secret {
    name = "${var.app_name}-${var.initqueue_name}-rabbitmq"
  }
}


resource "kubernetes_role" "orderqueue" {
  metadata {
    name      = "${var.app_name}-${var.initqueue_name}-rabbitmq-endpoint-reader"
    namespace = var.namespace
  }

  rule {
    api_groups     = [""]
    resources      = ["endpoints"]
    verbs          = ["get"]
  }
  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create"]
  }
}


resource "kubernetes_role_binding" "orderqueue" {
  depends_on = [kubernetes_service_account.orderqueue, kubernetes_role.orderqueue]
  
  metadata {
    name      = "${var.app_name}-${var.initqueue_name}-rabbitmq-endpoint-reader"
    namespace = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "${var.app_name}-${var.initqueue_name}-rabbitmq-endpoint-reader"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "${var.app_name}-${var.initqueue_name}-rabbitmq"
  }
}


resource "kubernetes_config_map" "orderqueue" {
  metadata {
    name      = "${var.app_name}-${var.initqueue_name}-rabbitmq-config"
    namespace = var.namespace
  }

  data = {
    "rabbitmq.conf" = <<EOT
      ## Username and password
      default_user = guest
      default_pass = guest
      ## Clustering
      cluster_formation.peer_discovery_backend  = rabbit_peer_discovery_k8s
      cluster_formation.k8s.host = kubernetes.default.svc.cluster.local
      cluster_formation.node_cleanup.interval = 10
      cluster_formation.node_cleanup.only_log_warning = true
      cluster_partition_handling = autoheal
      # queue master locator
      queue_master_locator = min-masters
      # enable guest user
      loopback_users.guest = false
    EOT
  }
}




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
      tier = var.initqueue_name
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
      tier = var.initqueue_name
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

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              weight = 1
              
              pod_affinity_term = {
               label_selector {
                 match_expressions {
                   key = "tier"
                   operator = "In"
                   values = [var.initqueue_name]
                 }
               }
              }
            }
          }
        }
        
        security_context {
          fs_group    = 1001
          run_as_user = 1001
        }
        
        
        container {
          name              = "rabbitmq"
          image             = "docker.io/bitnami/rabbitmq:3.8.9-debian-10-r64"
          image_pull_policy = "IfNotPresent"

          env {
            name  = "BITNAMI_DEBUG"
            value = "false"
          }
          
          env {
            name = "MY_POD_IP"
            value_from {
              field_ref {
                field_path = "status.podIP"  
              }  
            }
          }
          
          env {
            name = "MY_POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"  
              }  
            }
          }
          
          env {
            name = "MY_POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"  
              }  
            }
          }
          
          env {
            name  = "K8S_SERVICE_NAME"
            value = "${var.app_name}-${var.initqueue_name}-rabbitmq-headless"
          }
          
          env {
            name  = "K8S_ADDRESS_TYPE"
            value = "hostname"
          }
          
          env {
            name  = "RABBITMQ_FORCE_BOOT"
            value = "no"
          }
          
          env {
            name  = "RABBITMQ_NODE_NAME"
            value = "rabbit@$(MY_POD_NAME).$(K8S_SERVICE_NAME).$(MY_POD_NAMESPACE).svc.cluster.local"
          }
          
          env {
            name  = "K8S_HOSTNAME_SUFFIX"
            value = ".$(K8S_SERVICE_NAME).$(MY_POD_NAMESPACE).svc.cluster.local"
          }
          
          env {
            name  = "RABBITMQ_MNESIA_DIR"
            value = "/bitnami/rabbitmq/mnesia/$(RABBITMQ_NODE_NAME)"
          }
          
          env {
            name  = "RABBITMQ_LDAP_ENABLE"
            value = "no"
          }
          
          env {
            name  = "RABBITMQ_LOGS"
            value = "-"
          }
          
          env {
            name  = "RABBITMQ_ULIMIT_NOFILES"
            value = "65536"
          }
          
          env {
            name  = "RABBITMQ_USE_LONGNAME"
            value = "true"
          }
          
          env {
            name = "RABBITMQ_ERL_COOKIE"
            value_from {
              secret_key_ref {
                name = "${var.app_name}-${var.initqueue_name}-rabbitmq"
                key  = "rabbitmq-erlang-cookie"
              }  
            }
          }
          
          env {
            name  = "RABBITMQ_USERNAME"
            value = "guest"
          }
          
          env {
            name  = "RABBITMQ_PASSWORD"
            value = "guest"
          }
          
          env {
            name  = "RABBITMQ_PLUGINS"
            value = "rabbitmq_management, rabbitmq_peer_discovery_k8s, rabbitmq_auth_backend_ldap"
          }
          
          port {
            name           = "amqp"
            container_port = 5672
          }
          
          port {
            name           = "dist"
            container_port = 25672
          }
          
          port {
            name           = "stats"
            container_port = 15672
          }
          
          port {
            name           = "epmd"
            container_port = 4369
          }
          
          resources {
            limits = {
              cpu    = "1000m"
              memory = "2Gi"
            }

            requests = {
              cpu    = "1000m"
              memory = "2Gi"
            }
          }

          readiness_probe {
            exec {
              command = ["/bin/bash", "-ec", "rabbitmq-diagnostics -q check_running && rabbitmq-diagnostics -q check_local_alarms"]
            }

            initial_delay_seconds = 10
            period_seconds        = 30
            timeout_seconds       = 20
            success_threshold     = 1
            failure_threshold     = 3
          }
          
          liveness_probe {
            exec {
              command = ["/bin/bash", "-ec", "rabbitmq-diagnostics -q ping"]
            }

            initial_delay_seconds = 120
            period_seconds        = 30
            timeout_seconds       = 20
            success_threshold     = 1
            failure_threshold     = 3
          }
          
          lifecycle {
            pre_stop {
              exec {
                command = ["/bin/bash", "-ec", "- |\nif [[ -f /opt/bitnami/scripts/rabbitmq/nodeshutdown.sh ]]; then\n/opt/bitnami/scripts/rabbitmq/nodeshutdown.sh -t \"120\" -d  \"false\"\nelse\nrabbitmqctl stop_app\nfi\n"] 
              }
            }
          }

          volume_mount {
            name       = "configuration"
            mount_path = "/bitnami/rabbitmq/conf"
          }
          
          volume_mount {
            name       = "data"
            mount_path = "/bitnami/rabbitmq/mnesia"
          }
        }

        volume {
          name = "configuration"

          config_map {
            name = "${var.app_name}-${var.initqueue_name}-rabbitmq-config"
            items {
              key  = "rabbitmq.conf"
              path = "rabbitmq.conf"
            }
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

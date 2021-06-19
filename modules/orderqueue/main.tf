############################################################
# REQUIRED PROVIDERS
############################################################
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.2"
    }
  }
}


############################################################
# CREATE ORDERQUEUE DEPLOYMENT
############################################################
resource "kubernetes_pod_disruption_budget" "orderqueue" {
  metadata {
    name      = "${var.initqueue_name}-rabbitmq"
    namespace = var.namespace
  }
  spec {
    min_available = 1
    selector {
      match_labels = {
        tier = var.initqueue_name
      }
    }
  }
}


resource "kubernetes_service_account" "orderqueue" {
  metadata {
    name      = "${var.initqueue_name}-rabbitmq"
    namespace = var.namespace
  }
  secret {
    name = "${var.initqueue_name}-rabbitmq"
  }
}


resource "kubernetes_role" "orderqueue" {
  metadata {
    name      = "${var.initqueue_name}-rabbitmq-endpoint-reader"
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
    name      = "${var.initqueue_name}-rabbitmq-endpoint-reader"
    namespace = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "${var.initqueue_name}-rabbitmq-endpoint-reader"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "${var.initqueue_name}-rabbitmq"
  }
}


resource "kubernetes_service" "orderqueue_headless" {
  metadata {
    name      = "${var.initqueue_name}-rabbitmq-headless"
    namespace = var.namespace
  }
  spec {
    selector = {
      tier = var.initqueue_name
    }
    
    cluster_ip = "None"
    
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
      target_port = "stats"
    }
  }
}


resource "kubernetes_service" "orderqueue" {
  metadata {
    name      = "${var.initqueue_name}-rabbitmq"
    namespace = var.namespace
  }
  spec {
    selector = {
      tier = var.initqueue_name
    }
    
    type = "ClusterIP"
    
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
      target_port = "stats"
    }
  }
}


resource "helm_release" "orderqueue" {
  depends_on = [kubernetes_pod_disruption_budget.orderqueue, kubernetes_role_binding.orderqueue, kubernetes_service.orderqueue_headless, kubernetes_service.orderqueue]
  
  name       = "orderqueue"

  chart      = "${path.module}/helm/"

  namespace  = var.namespace
  
  set {
    name  = "appname"
    value = var.app_name
  }

  set {
    name  = "initqueue_name"
    value = var.initqueue_name
  }
}

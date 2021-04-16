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
# CREATE PROCUREMENT RESPONSESVC DEPLOYMENT
############################################################
resource "kubernetes_config_map" "responsesvc" {
  metadata {
    name = "action-response-services"
    namespace = var.namespace
  }

  data = {
    APPDYNAMICS_LOGGER_LEVEL       = "debug"
    APPDYNAMICS_LOGGER_OUTPUT_TYPE = "console"
  }
}


resource "kubernetes_service" "action-response-services" {
  metadata {
    name      = "action-response-services"
    namespace = var.namespace
  }
  spec {
    type = "ClusterIP"
    
    selector = {
      app  = "action-response-services"
    }
    
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 8001
      target_port = 80
    }
  }
}


resource "kubernetes_service" "billing-services" {
  metadata {
    name      = "billing-services"
    namespace = var.namespace
  }
  spec {
    type = "ClusterIP"
    
    selector = {
      app  = "action-response-services"
    }
    
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 8080
      target_port = 80
    }
  }
}


resource "kubernetes_service" "auth-services" {
  metadata {
    name      = "auth-services"
    namespace = var.namespace
  }
  spec {
    type = "ClusterIP"
    
    selector = {
      app  = "action-response-services"
    }
    
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 8080
      target_port = 80
    }
  }
}



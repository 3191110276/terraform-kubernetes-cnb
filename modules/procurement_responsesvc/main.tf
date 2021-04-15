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


resource "kubernetes_deployment" "action-response-services" {
  metadata {
    name = "action-response-services"
    labels = {
      name = "action-response-services"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "action-response-services"
      }
    }

    template {
      metadata {
        labels = {
          name = "action-response-services"
          app  = "action-response-services"
        }
      }

      spec {
        service_account_name = "appdynamics-cluster-agent"
        
        container {
          image = "astoklas/apm-game-nodejs:latest"
          name  = "action-response-services"

          port {
            container_port = 80
          }
          
          env {
            name  = "APP_CONFIG"
            value = "{\"type\": \"nodejs\",\"agent\": \"no\",\"port\": 3009,\"endpoints\": {\"http\": {\"actionResponseServices/updateAction\": [\"cache,1024\", {\"call\": \"slow,800\",\"probability\": 0.1}],\"actionResponseServices/chat\": [\"cache,128\", {\"call\": \"slow,800\",\"probability\": 0.1}],\"AuthServices/login\": [\"cache,128\", {\"call\": \"slow,800\",\"probability\": 0.1}],\"BillingServices/purchaseGamePass\": [\"cache,128\", {\"call\": \"slow,800\",\"probability\": 0.1}],\"/health\": [\"cache,128\"]}},\"name\": \"backend\",\"nodeid\": 0}"
          }
          
          env {
            name  = "APM_CONFIG"
            value = "{\"controller\":\"http://a.b.c.d:8090\",\"accountName\":\"customer1\",\"accountAccessKey\":\"secret_to_be_insert_here\",\"applicationName\":\"apm_game\",\"eventsService\":\"http://a.b.c.d:9080\",\"globalAccountName\":\"customer1_\",\"eum\":{\"appKey\":\"XXX-XXX-XXX\",\"adrumExtUrlHttp\":\"http://cdn.appdynamics.com\",\"adrumExtUrlHttps\":\"https://cdn.appdynamics.com\",\"beaconUrlHttp\":\"http://a.b.c.d:7001\",\"beaconUrlHttps\":\"https://a.b.c.d:7002\"}}"
          }
          
          env {
            name  = "WITH_AGENT"
            value = "0"
          }
          
          env {
            name  = "CUSTOM_CODE_DIR"
            value = "/scripts"
          }
          
          env {
            name  = "LOG_DIRECTORY"
            value = "logs/nodejs/backend-0/"
          }
          
          env {
            name  = "WITH_ANALYTICS"
            value = "1"
          }
          
          env_from {
            config_map_ref {
              name = "action-response-services"  
            }  
          }
          
          command = ["/app/node.sh"]
          
          resources {
            limits = {
              cpu    = "200M"
              memory = "900Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "600Mi"
            }
          }
        }
      }
    }
  }
}

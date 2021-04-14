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
# DEPLOY HELM CHART
############################################################
resource "helm_release" "procurement" {
  name       = "procurement"

  chart      = "${path.module}/helm/"

  namespace  = "procurement"

  set {
    name  = "component1"
    value = "edge-collector"
  }

  set {
    name  = "component2"
    value = "analytics-services"
  }
  
  set {
    name  = "component3"
    value = "telehealth-portal"
  }
  
  set {
    name  = "component4"
    value = "diagnostics-engine"
  }
  
  set {
    name  = "component5"
    value = "customer-portal"
  }
  
  set {
    name  = "component6"
    value = "app-load"
  }
  
  set {
    name  = "component7"
    value = "action-response-services"
  }
  
  set {
    name  = "component8"
    value = "ai-services"
  }
  
  set {
    name  = "component9"
    value = "player-action-services"
  }
  
  set {
    name  = "component10"
    value = "model-training"
  }
  
  set {
    name  = "component11"
    value = "heavy-data"
  }
  
  set {
    name  = "component1_replicas"
    value = "3"
  }
  
  set {
    name  = "component2_replicas"
    value = "1"
  }
  
  set {
    name  = "component3_replicas"
    value = "1"
  }
  
  set {
    name  = "component4_replicas"
    value = "1"
  }
  
  set {
    name  = "component5_replicas"
    value = "1"
  }
  
  set {
    name  = "component6_replicas"
    value = "3"
  }
  
  set {
    name  = "component7_replicas"
    value = "1"
  }
  
  set {
    name  = "component8_replicas"
    value = "1"
  }
  
  set {
    name  = "component9_replicas"
    value = "1"
  }
  
  set {
    name  = "component10_replicas"
    value = "6"
  }
  
  set {
    name  = "component11_replicas"
    value = "3"
  }
  
  set {
    name  = "default_cpu_limits"
    value = "200m"
  }
  
  set {
    name  = "default_mem_limits"
    value = "900M"
  }
  
  set {
    name  = "default_cpu_requests"
    value = "100m"
  }
  
  set {
    name  = "default_mem_requests"
    value = "600M"
  }
}

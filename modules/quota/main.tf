resource "kubernetes_limit_range" "main" {
  metadata {
    name      = "limit-range"
    namespace = var.namespace
  }
  spec {
    limit {
      type = "Container"
      default = {
        cpu    = "500m"
        memory = "256Mi"
      }
      default_request = {
        cpu    = "125m"
        memory = "65Mi"
      }
    }
  }
}


resource "kubernetes_resource_quota" "main" {
  metadata {
    name      = "quota"
    namespace = var.namespace
  }
  spec {
    hard = {
      "pods"     = 200
      "secrets"  = 100
      "replicationcontrollers" = 50
      "services" = 100
      "services.loadbalancers" = 2
      "requests.cpu" = "5"
      "requests.memory" = "12Gi"
      "limits.cpu" = "20"
      "limits.memory" = "40Gi"
      "persistentvolumeclaims" = 10
      "requests.nvidia.com/gpu" = 0
    }
  }
}

resource "kubernetes_ingress" "ingress" {
  metadata {
    name      = "${var.app_name}-ingress"
    namespace = var.namespace
    
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/$2$3"
    }
  }

  spec {
    rule {
      http {
        path {
          path = "/()()(.*)"
          backend {
            service_name = "${var.app_name}-${var.orderfile_name}"
            service_port = 80
          }
        }
        path {
          path = "/(admin)(/|$)(.*)"
          backend {
            service_name = "${var.app_name}-${var.adminfile_name}"
            service_port = 80
          }
        }
        path {
          path = "/(api)(/)(order)"
          backend {
            service_name = "${var.app_name}-${var.order_name}"
            service_port = 80
          }
        }
        path {
          path = "/(rabbitmq)(/|$)(.*)"
          backend {
            service_name = "${var.app_name}-${var.initqueue_name}-rabbitmq"
            service_port = 15672
          }
        }
      }
    }
  }
}

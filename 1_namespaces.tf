############################################################
# KUBERNETES NAMESPACES
############################################################
resource "kubernetes_namespace" "order" {
  metadata {
    name = var.order_namespace
  }
}


resource "kubernetes_namespace" "trafficgen" {
  metadata {
    name = var.trafficgen_namespace
  }
}


resource "kubernetes_namespace" "extprod" {
  metadata {
    name = var.extprod_namespace
  }
}


resource "kubernetes_namespace" "extpayment" {
  metadata {
    name = var.extpayment_namespace
  }
}


resource "kubernetes_namespace" "accounting" {
  metadata {
    name = var.accounting_namespace
  }
}


resource "kubernetes_namespace" "procurement" {
  metadata {
    name = var.procurement_namespace
  }
}

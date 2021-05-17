############################################################
# KUBERNETES NAMESPACES
############################################################
resource "kubernetes_namespace" "order" {
  count = var.deploy_order ? 1 : 0
  
  timeouts {
    delete = "3600s"
  }
  
  metadata {
    name = var.order_namespace
    labels = {
      "istio.io/rev" = var.istioLabel
    }   
  }
}


resource "kubernetes_namespace" "trafficgen" {
  count = var.deploy_trafficgen ? 1 : 0
  
  timeouts {
    delete = "3600s"
  }
  
  metadata {
    name = var.trafficgen_namespace
    labels = {
      "istio.io/rev" = var.istioLabel
    }
  }
}


resource "kubernetes_namespace" "extprod" {
  count = var.deploy_extprod ? 1 : 0
  
  timeouts {
    delete = "3600s"
  }
  
  metadata {
    name = var.extprod_namespace
    labels = {
      "istio.io/rev" = var.istioLabel
    }
  }
}


resource "kubernetes_namespace" "extpayment" {
  count = var.deploy_extpayment ? 1 : 0
  
  timeouts {
    delete = "3600s"
  }
  
  metadata {
    name = var.extpayment_namespace
    labels = {
      "istio.io/rev" = var.istioLabel
    }    
  }
}


resource "kubernetes_namespace" "accounting" {
  count = var.deploy_accounting ? 1 : 0
  
  timeouts {
    delete = "3600s"
  }
  
  metadata {
    name = var.accounting_namespace
    labels = {
      "istio.io/rev" = var.istioLabel
    }
  }
}


resource "kubernetes_namespace" "procurement" {
  count = var.deploy_procurement ? 1 : 0
  
  timeouts {
    delete = "3600s"
  }
  
  metadata {
    name = var.procurement_namespace
    labels = {
      "istio.io/rev" = var.istioLabel
    }
  }
}

resource "kubernetes_config_map" "customization" {
  metadata {
    name      = "customization"
    namespace = var.namespace
  }

  data = {
    INVENTORYDB_SVC     = var.inventorydb_service
    PAYMENT_SVC         = var.payment_service
    EXTPAYMENT_SVC      = var.extpayment_service
    INITQUEUE_SVC       = var.initqueue_service
    ORDERPROCESSING_SVC = var.orderprocessing_service
    PRODUCTION_SVC      = var.production_service
    EXTPROD_SVC         = var.extprod_service
    FULFILMENT_SVC      = var.fulfilment_service
  }
}

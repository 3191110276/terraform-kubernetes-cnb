############################################################
# INPUT VARIABLES
############################################################
variable "namespace" {
  type        = string
  default     = "order"
  description = "Namespace used for deploying the customization ConfigMap. This namespace has to exist and is not provisioned by this module."
}

variable "inventorydb_service" {
  type        = string
  default     = "inventorydb-service"
  description = "Service for the InventoryDB application component."
}

variable "payment_service" {
  type        = string
  default     = "payment"
  description = "Service for the Payment application component."
}

variable "extpayment_service" {
  type        = string
  default     = "payment.ext"
  description = "Service for the ExtPayment application component."
}

variable "initqueue_service" {
  type        = string
  default     = "initqueue-rabbitmq"
  description = "Service for the Initqueue application component."
}

variable "orderprocessing_service" {
  type        = string
  default     = "orderprocessing"
  description = "Service for the Orderprocessing application component."
}

variable "production_service" {
  type        = string
  default     = "production"
  description = "Service for the Production application component."
}

variable "extprod_service" {
  type        = string
  default     = "gateway.production"
  description = "Service for the ExtProd application component."
}

variable "fulfilment_service" {
  type        = string
  default     = "fulfilment"
  description = "Service for the Fulfilment application component."
}

############################################################
# INPUT VARIABLES
############################################################
variable "order_namespace" {
  type        = string
  default     = "order"
  description = "Namespace used for deploying the object. This namespace has to exist and is not provisioned by this submodule."
}

variable "ext_namespace" {
  type        = string
  default     = "ext"
  description = "Namespace used for deploying the object. This namespace has to exist and is not provisioned by this submodule."
}

variable "production_namespace" {
  type        = string
  default     = "production"
  description = "Namespace used for deploying the object. This namespace has to exist and is not provisioned by this submodule."
}

variable "procurement_namespace" {
  type        = string
  default     = "procurement"
  description = "Namespace used for deploying the object. This namespace has to exist and is not provisioned by this submodule."
}

variable "order_app_name" {
  type        = string
  default     = "demo-order"
  description = "The name of the application that this submodule is part of."
}

variable "extprod_name" {
  type        = string
  default     = "gateway"
  description = "The name of the ExtProd application component. Changing this value will change how the application component is called in Kubernetes."
}

variable "extpayment_name" {
  type        = string
  default     = "payment"
  description = "The name of the ExtPayment application component. Changing this value will change how the application component is called in Kubernetes."
}

variable "fulfilment_name" {
  type        = string
  default     = "fulfilment"
  description = "The name of the Fulfilment application component. Changing this value will change how the application component is called in Kubernetes."
}

variable "adminfile_name" {
  type        = string
  default     = "adminfile"
  description = "The name of the AdminFile application component. Changing this value will change how the application component is called in various UIs."
}

variable "procprediction_name" {
  type        = string
  default     = "prediction-service"
  description = "The name of the ProcurementPrediction application component. Changing this value will change how the application component is called in various UIs."
}

variable "procexternal_name" {
  type        = string
  default     = "external-procurement"
  description = "The name of the ProcurementExternal application component. Changing this value will change how the application component is called in various UIs."
}

variable "procedgeagg_name" {
  type        = string
  default     = "edge-aggregator"
  description = "The name of the ProcurementEdgeAgg application component. Changing this value will change how the application component is called in various UIs."
}

variable "deploy_order" {
  type        = bool
  default     = true
  description = "Determines if the Order component will be deployed."
}

variable "deploy_extprod" {
  type        = bool
  default     = true
  description = "Determines if the ExtProd component will be deployed."
}

variable "deploy_extpayment" {
  type        = bool
  default     = true
  description = "Determines if the ExtPayment component will be deployed."
}

variable "deploy_procurement" {
  type        = bool
  default     = true
  description = "Determines if the Procurement component will be deployed."
}

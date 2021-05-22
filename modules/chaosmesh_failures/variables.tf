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

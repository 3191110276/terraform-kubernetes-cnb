############################################################
# INPUT VARIABLES
############################################################
variable "namespace" {
  type        = string
  default     = "order"
  description = "Namespace used for deploying the object. This namespace has to exist and is not provisioned by this submodule."
}

variable "app_name" {
  type        = string
  default     = "cnb"
  description = "The name of the application that this submodule is part of."
}

variable "initqueue_name" {
  type        = string
  default     = "orderqueue"
  description = "The name of the application component deployed through this submodule. Changing this value will change how the application component is called in Kubernetes."
}

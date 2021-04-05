############################################################
# GENERAL
############################################################
variable "namespace" {
  type        = string
  default     = "brewery"
  description = "Namespace used for deploying the object. This namespace has to exist and is not provisioned by this submodule."
}


variable "app_name" {
  type        = string
  default     = "cnb"
  description = "The name of the application that this submodule is part of."
}


variable "orderfile_name" {
  type        = string
  default     = "orderfile"
  description = "The name of the OrderFile application component. Changing this value will change how the application component is called in various UIs."
}

variable "adminfile_name" {
  type        = string
  default     = "adminfile"
  description = "The name of the AdminFile application component. Changing this value will change how the application component is called in various UIs."
}


variable "order_name" {
  type        = string
  default     = "order"
  description = "The name of the Order application component. Changing this value will change how the application component is called in Kubernetes."
}


variable "initqueue_name" {
  type        = string
  default     = "initqueue"
  description = "The name of the InitQueue application component. Changing this value will change how the application component is called in Kubernetes."
}

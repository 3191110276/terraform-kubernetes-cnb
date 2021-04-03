############################################################
# INPUT VARIABLES
############################################################
variable "namespace" {
  type        = string
  default     = "brewery"
  description = "Namespace used for deploying the object. This namespace has to exist and is not provisioned by this submodule."
}

variable "app_name" {
  type        = string
  default     = "brewery"
  description = "The name of the application that this submodule is part of."
}

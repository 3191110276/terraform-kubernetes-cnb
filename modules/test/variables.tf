############################################################
# INPUT VARIABLES
############################################################
variable "namespace" {
  type        = string
  default     = "order"
  description = "Namespace used for deploying the object. This namespace has to exist and is not provisioned by this submodule."
}

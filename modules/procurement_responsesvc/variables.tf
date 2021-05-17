############################################################
# INPUT VARIABLES
############################################################
variable "namespace" {
  type        = string
  default     = "procurement"
  description = "Namespace used for deploying the object. This namespace has to exist and is not provisioned by this submodule."
}

variable "procurement_app_name" {
  type        = string
  default     = "cnb-procurement"
  description = "The name of the procurement application."
}

variable "appd_account_name" {
  type        = string
  description = "Account name of the AppDynamics account."
}

variable "appd_controller_hostname" {
  type        = string
  description = "Hostname of the AppDynamics controller."
}

variable "appd_controller_port" {
  type        = string
  description = "Port of the AppDynamics controller."
}

variable "appd_controller_key" {
  type        = string
  description = "Controller key of the AppDynamics controller."
}

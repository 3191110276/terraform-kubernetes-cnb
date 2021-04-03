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
  default     = "cnb"
  description = "The name of the application that this submodule is part of."
}

variable "appd_browserapp_key" {
  type        = string
  description = "Key for the AppDynamics EUM application."
}

variable "appd_browserapp_beaconurl" {
  type        = string
  description = "Beacon URL for the AppDynamics EUM server."
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

variable "appd_controller_ssl" {
  type        = bool
  default     = true
  description = "Determines if the AppDynamics controller uses SSL."
}

variable "use_proxy" {
  type        = bool
  default     = false
  description = "Determines if a proxy should be used for connections to AppDynamics."
}

variable "proxy_host" {
  type        = string
  default     = ""
  description = "Proxy hostname for connections to the AppDynamics controller. Only needed if the connection uses proxy."
}

variable "proxy_port" {
  type        = string
  default     = "443"
  description = "Proxy port for connections to the AppDynamics controller. Only needed if the connection uses proxy."
}

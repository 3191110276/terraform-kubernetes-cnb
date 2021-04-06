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

variable "payment_name" {
  type        = string
  default     = "payment"
  description = "The name of the application component deployed through this submodule. Changing this value will change how the application component is called in Kubernetes."
}

variable "payment_appd" {
  type        = string
  default     = "Payment"
  description = "The name of the application component deployed through this submodule. Changing this value will change how the application component is called in AppDynamics."
}

variable "replicas" {
  type        = number
  default     = 2
  description = "The number of replicas that should initially be deployed for this component."
}

variable "cpu_request" {
  type        = string
  default     = "20m"
  description = "The value for requests.cpu."
}

variable "memory_request" {
  type        = string
  default     = "64Mi"
  description = "The value for requests.memory."
}

variable "cpu_limit" {
  type        = string
  default     = "250m"
  description = "The value for limits.cpu."
}

variable "memory_limit" {
  type        = string
  default     = "256Mi"
  description = "The value for limits.memory."
}

variable "registry" {
  type        = string
  default     = "mimaurer"
  description = "The registry from which the application image is pulled."
}

variable "payment_tech" {
  type        = string
  default     = "nodejs"
  description = "The image technology."
}

variable "payment_version" {
  type        = string
  default     = "master"
  description = "The version tag referencing the image that will be pulled from the registry"
}

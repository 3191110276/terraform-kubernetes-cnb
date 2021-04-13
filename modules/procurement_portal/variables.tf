############################################################
# INPUT VARIABLES
############################################################
variable "namespace" {
  type        = string
  default     = "procurement"
  description = "Namespace used for deploying the object. This namespace has to exist and is not provisioned by this submodule."
}

variable "procportal_name" {
  type        = string
  default     = "procurement-portal"
  description = "The name of the application component deployed through this submodule. Changing this value will change how the application component is called in Kubernetes."
}

variable "replicas" {
  type        = number
  default     = 2
  description = "The number of replicas that should initially be deployed for this component."
}

variable "cpu_request" {
  type        = string
  default     = "100m"
  description = "The value for requests.cpu."
}

variable "memory_request" {
  type        = string
  default     = "600Mi"
  description = "The value for requests.memory."
}

variable "cpu_limit" {
  type        = string
  default     = "200m"
  description = "The value for limits.cpu."
}

variable "memory_limit" {
  type        = string
  default     = "900Mi"
  description = "The value for limits.memory."
}

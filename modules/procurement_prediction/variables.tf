############################################################
# INPUT VARIABLES
############################################################
variable "namespace" {
  type        = string
  default     = "procurement"
  description = "Namespace used for deploying the object. This namespace has to exist and is not provisioned by this submodule."
}

variable "procprediction_name" {
  type        = string
  default     = "prediction-service"
  description = "The name of the application component deployed through this submodule. Changing this value will change how the application component is called in Kubernetes."
}

variable "replicas" {
  type        = number
  default     = 2
  description = "The number of replicas that should initially be deployed for this component."
}

variable "cpu_request" {
  type        = string
  default     = "250m"
  description = "The value for requests.cpu."
}

variable "memory_request" {
  type        = string
  default     = "400Mi"
  description = "The value for requests.memory."
}

variable "cpu_limit" {
  type        = string
  default     = "500m"
  description = "The value for limits.cpu."
}

variable "memory_limit" {
  type        = string
  default     = "1000Mi"
  description = "The value for limits.memory."
}

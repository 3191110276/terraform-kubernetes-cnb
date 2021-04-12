############################################################
# INPUT VARIABLES
############################################################
variable "namespace" {
  type        = string
  default     = "automation"
  description = "Namespace used for deploying the object. This namespace has to exist and is not provisioned by this submodule."
}

variable "app_name" {
  type        = string
  default     = "cnb"
  description = "The name of the application that this submodule is part of."
}

variable "extprod_name" {
  type        = string
  default     = "production"
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
  default     = "128Mi"
  description = "The value for requests.memory."
}

variable "cpu_limit" {
  type        = string
  default     = "400m"
  description = "The value for limits.cpu."
}

variable "memory_limit" {
  type        = string
  default     = "512Mi"
  description = "The value for limits.memory."
}

variable "registry" {
  type        = string
  default     = "mimaurer"
  description = "The registry from which the application image is pulled."
}

variable "extprod_tech" {
  type        = string
  default     = "python"
  description = "The image technology."
}

variable "extprod_version" {
  type        = string
  default     = "master"
  description = "The version tag referencing the image that will be pulled from the registry"
}

variable "min_delay" {
  type        = string
  default     = "0"
  description = "The minimum amount of artificial delay for requests to external production."
}

variable "max_delay" {
  type        = string
  default     = "1000"
  description = "The maximum amount of artificial delay for requests to external production."
}

variable "job_min_delay" {
  type        = string
  default     = "240"
  description = "The minimum processing time requests to external production."
}

variable "job_max_delay" {
  type        = string
  default     = "360"
  description = "The maximum processing time requests to external production."
}

variable "production_svc" {
  type        = string
  default     = "cnb-production.brewery"
  description = "The service name for the Order production application component."
}

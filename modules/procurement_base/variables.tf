############################################################
# INPUT VARIABLES
############################################################
variable "namespace" {
  type        = string
  default     = "procurement"
  description = "Namespace used for deploying the object. This namespace has to exist and is not provisioned by this submodule."
}

variable "app_name" {
  type        = string
  default     = "procurement"
  description = "The name of the application that this submodule is part of."
}

variable "pod_quota" {
  type        = number
  default     = 100
  description = "Quota for Pods"
}

variable "cpu_request_quota" {
  type        = string
  default     = "100"
  description = "Quota for requests.cpu"
}

variable "cpu_limit_quota" {
  type        = string
  default     = "100"
  description = "Quota for limits.cpu"
}

variable "memory_request_quota" {
  type        = string
  default     = "100G"
  description = "Quota for requests.memory"
}

variable "memory_limit_quota" {
  type        = string
  default     = "100G"
  description = "Quota for limits.memory"
}

variable "pvc_quota" {
  type        = number
  default     = 5
  description = "Quota for PVCs"
}

variable "storage_quota" {
  type        = string
  default     = "100G"
  description = "Quota for storage"
}

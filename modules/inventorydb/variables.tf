############################################################
# INPUT VARIABLES
############################################################
variable "namespace" {
  type        = string
  default     = "order"
  description = "Namespace used for deploying the object. This namespace has to exist and is not provisioned by this submodule."
}

variable "app_name" {
  type        = string
  default     = "cnb"
  description = "The name of the application that this submodule is part of."
}

variable "inventorydb_name" {
  type        = string
  default     = "inventorydb"
  description = "The name of the application component deployed through this submodule. Changing this value will change how the application component is called in Kubernetes."
}

variable "registry" {
  type        = string
  default     = "mimaurer"
  description = "The registry from which the application image is pulled."
}

variable "inventorydb_tech" {
  type        = string
  default     = "mariadb"
  description = "The image technology."
}

variable "inventorydb_version" {
  type        = string
  default     = "master"
  description = "The version tag referencing the image that will be pulled from the registry"
}

############################################################
# INPUT VARIABLES
############################################################
variable "namespace" {
  type    = string
  default = "extpayment"
}

variable "registry" {
  type    = string
  default = "mimaurer"
}

variable "image_tag" {
  type    = string
  default = "master"
}

variable "trafficgen_name" {
  type    = string
  default = "trafficgen"
}

variable "trafficgen_replicas" {
  type    = number
  default = 10
}

variable "trafficgen_min_random_delay" {
  type    = number
  default = 0
}

variable "trafficgen_max_random_delay" {
  type    = number
  default = 60
}

variable "trafficgen_app_endpoint" {
  type    = string
  default = "ingress-nginx-controller.ccp"
}

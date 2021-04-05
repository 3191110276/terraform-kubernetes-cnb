############################################################
# GENERAL
############################################################
variable "main_namespace" {
  type        = string
  default     = "brewery"
  description = "Namespace used for deploying the object. This namespace has to exist and is not provisioned by this submodule."
}

variable "trafficgen_namespace" {
  type    = string
  default = "trafficgen"
}

variable "app_name" {
  type        = string
  default     = "cnb"
  description = "The name of the application that this submodule is part of."
}


############################################################
# APPDYNAMICS
############################################################
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


############################################################
# TRAFFICGEN
############################################################
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

variable "trafficgen_lagspike_percentage" {
  type    = string
  default = ""
}

variable "trafficgen_app_endpoint" {
  type    = string
  default = "essential-nginx-ingress-ingress-nginx-controller.iks"
}


############################################################
# ORDERFILE
############################################################
variable "orderfile_name" {
  type        = string
  default     = "orderfile"
  description = "The name of the OrderFile application component. Changing this value will change how the application component is called in various UIs."
}

variable "orderfile_replicas" {
  type        = number
  default     = 2
  description = "The number of replicas that should initially be deployed for the OrderFile component."
}

variable "orderfile_cpu_request" {
  type        = string
  default     = "20m"
  description = "The OrderFile value for requests.cpu."
}

variable "orderfile_memory_request" {
  type        = string
  default     = "32Mi"
  description = "The OrderFile value for requests.memory."
}

variable "orderfile_cpu_limit" {
  type        = string
  default     = "50m"
  description = "The OrderFile value for limits.cpu."
}

variable "orderfile_memory_limit" {
  type        = string
  default     = "32Mi"
  description = "The OrderFile value for limits.memory."
}


############################################################
# ORDER
############################################################
variable "order_name" {
  type        = string
  default     = "order"
  description = "The name of the Order application component. Changing this value will change how the application component is called in Kubernetes."
}

variable "order_appd" {
  type        = string
  default     = "Order"
  description = "The name of the Order application component. Changing this value will change how the application component is called in AppDynamics."
}

variable "order_replicas" {
  type        = number
  default     = 2
  description = "The number of replicas that should initially be deployed for the Order component."
}

variable "order_cpu_request" {
  type        = string
  default     = "100m"
  description = "The Order value for requests.cpu."
}

variable "order_memory_request" {
  type        = string
  default     = "128Mi"
  description = "The Order value for requests.memory."
}

variable "order_cpu_limit" {
  type        = string
  default     = "400m"
  description = "The Order value for limits.cpu."
}

variable "order_memory_limit" {
  type        = string
  default     = "512Mi"
  description = "The Order value for limits.memory."
}


############################################################
# CUSTOMIZATION
############################################################
variable "inventorydb_service" {
  type        = string
  default     = "cnb-inventorydb-service"
  description = "Service for the InventoryDB application component."
}

variable "payment_service" {
  type        = string
  default     = "cnb-payment"
  description = "Service for the Payment application component."
}

variable "extpayment_service" {
  type        = string
  default     = "payment.ext"
  description = "Service for the ExtPayment application component."
}

variable "initqueue_service" {
  type        = string
  default     = "cnb-initqueue-rabbitmq"
  description = "Service for the Initqueue application component."
}

variable "orderprocessing_service" {
  type        = string
  default     = "cnb-orderprocessing"
  description = "Service for the Orderprocessing application component."
}

variable "production_service" {
  type        = string
  default     = "cnb-production"
  description = "Service for the Production application component."
}

variable "extprod_service" {
  type        = string
  default     = "production.automation"
  description = "Service for the ExtProd application component."
}

variable "fulfilment_service" {
  type        = string
  default     = "cnb-fulfilment"
  description = "Service for the Fulfilment application component."
}

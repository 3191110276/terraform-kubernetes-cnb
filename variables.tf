############################################################
# GENERAL
############################################################
variable "order_namespace" {
  type        = string
  default     = "order"
  description = "Namespace used for deploying the object. This namespace has to exist and is not provisioned by this submodule."
}

variable "trafficgen_namespace" {
  type    = string
  default = "trafficgen"
}

variable "extprod_namespace" {
  type    = string
  default = "production"
}

variable "extpayment_namespace" {
  type    = string
  default = "ext"
}

variable "accounting_namespace" {
  type    = string
  default = "accounting"
}

variable "procurement_namespace" {
  type    = string
  default = "procurement"
}

variable "order_app_name" {
  type        = string
  default     = "cnb-order"
  description = "The name of the order application."
}

variable "procurement_app_name" {
  type        = string
  default     = "cnb-procurement"
  description = "The name of the procurement application."
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
# ORDERQUEUE
############################################################
variable "orderqueue_name" {
  type        = string
  default     = "orderqueue"
  description = "The name of the OrderQueue application component. Changing this value will change how the application component is called in Kubernetes."
}


############################################################
# INVENTORYDB
############################################################
variable "inventorydb_name" {
  type        = string
  default     = "inventorydb"
  description = "The name of the InventoryDB application component. Changing this value will change how the application component is called in various UIs."
}


############################################################
# FULFILMENT
############################################################
variable "fulfilment_name" {
  type        = string
  default     = "fulfilment"
  description = "The name of the Fulfilment application component. Changing this value will change how the application component is called in Kubernetes."
}

variable "fulfilment_appd" {
  type        = string
  default     = "Fulfilment"
  description = "The name of the Fulfilment application component. Changing this value will change how the application component is called in AppDynamics."
}

variable "fulfilment_replicas" {
  type        = number
  default     = 2
  description = "The number of replicas that should initially be deployed for the Fulfilment component."
}

variable "fulfilment_cpu_request" {
  type        = string
  default     = "100m"
  description = "The Fulfilment value for requests.cpu."
}

variable "fulfilment_memory_request" {
  type        = string
  default     = "200Mi"
  description = "The Fulfilment value for requests.memory."
}

variable "fulfilment_cpu_limit" {
  type        = string
  default     = "400m"
  description = "The Fulfilment value for limits.cpu."
}

variable "fulfilment_memory_limit" {
  type        = string
  default     = "800Mi"
  description = "The Fulfilment value for limits.memory."
}


############################################################
# EXTPROD
############################################################
variable "extprod_name" {
  type        = string
  default     = "gateway"
  description = "The name of the ExtProd application component. Changing this value will change how the application component is called in Kubernetes."
}

variable "extprod_replicas" {
  type        = number
  default     = 2
  description = "The number of replicas that should initially be deployed for the ExtProd component."
}

variable "extprod_cpu_request" {
  type        = string
  default     = "100m"
  description = "The ExtProd value for requests.cpu."
}

variable "extprod_memory_request" {
  type        = string
  default     = "128Mi"
  description = "The ExtProd value for requests.memory."
}

variable "extprod_cpu_limit" {
  type        = string
  default     = "400m"
  description = "The ExtProd value for limits.cpu."
}

variable "extprod_memory_limit" {
  type        = string
  default     = "512Mi"
  description = "The ExtProd value for limits.memory."
}

variable "extprod_min_delay" {
  type        = string
  default     = "0"
  description = "The minimum amount of artificial delay for requests to ExtProd."
}

variable "extprod_max_delay" {
  type        = string
  default     = "1000"
  description = "The maximum amount of artificial delay for requests to ExtProd."
}

variable "extprod_job_min_delay" {
  type        = string
  default     = "240"
  description = "The minimum processing time requests to ExtProd."
}

variable "extprod_job_max_delay" {
  type        = string
  default     = "360"
  description = "The maximum processing time requests to ExtProd."
}


############################################################
# PRODUCTION
############################################################
variable "production_name" {
  type        = string
  default     = "production"
  description = "The name of the Production application component. Changing this value will change how the application component is called in Kubernetes."
}

variable "production_appd" {
  type        = string
  default     = "Production"
  description = "The name of the Production application component. Changing this value will change how the application component is called in AppDynamics."
}

variable "production_replicas" {
  type        = number
  default     = 2
  description = "The number of replicas that should initially be deployed for the Production component."
}

variable "production_cpu_request" {
  type        = string
  default     = "100m"
  description = "The Production value for requests.cpu."
}

variable "production_memory_request" {
  type        = string
  default     = "200Mi"
  description = "The Production value for requests.memory."
}

variable "production_cpu_limit" {
  type        = string
  default     = "400m"
  description = "The Production value for limits.cpu."
}

variable "production_memory_limit" {
  type        = string
  default     = "800Mi"
  description = "The Production value for limits.memory."
}


############################################################
# EXTPAYMENT
############################################################
variable "extpayment_name" {
  type        = string
  default     = "payment"
  description = "The name of the ExtPayment application component. Changing this value will change how the application component is called in Kubernetes."
}

variable "extpayment_replicas" {
  type        = number
  default     = 2
  description = "The number of replicas that should initially be deployed for the ExtPayment component."
}

variable "extpayment_cpu_request" {
  type        = string
  default     = "100m"
  description = "The ExtPayment value for requests.cpu."
}

variable "extpayment_memory_request" {
  type        = string
  default     = "128Mi"
  description = "The ExtPayment value for requests.memory."
}

variable "extpayment_cpu_limit" {
  type        = string
  default     = "400m"
  description = "The ExtPayment value for limits.cpu."
}

variable "extpayment_memory_limit" {
  type        = string
  default     = "512Mi"
  description = "The ExtPayment value for limits.memory."
}

variable "extpayment_min_random_delay" {
  type        = string
  default     = "0"
  description = "The minimum processing time requests to ExtPayment."
}

variable "extpayment_max_random_delay" {
  type        = string
  default     = "1000"
  description = "The maximum processing time requests to ExtPayment."
}

variable "extpayment_lagspike_percentage" {
  type        = string
  default     = "0.01"
  description = "The service name for ExtPayment."
}


############################################################
# PAYMENT
############################################################
variable "payment_name" {
  type        = string
  default     = "payment"
  description = "The name of the Payment application component. Changing this value will change how the application component is called in Kubernetes."
}

variable "payment_appd" {
  type        = string
  default     = "Payment"
  description = "The name of the Payment application component. Changing this value will change how the application component is called in AppDynamics."
}

variable "payment_replicas" {
  type        = number
  default     = 2
  description = "The number of replicas that should initially be deployed for the Payment component."
}

variable "payment_cpu_request" {
  type        = string
  default     = "20m"
  description = "The Payment value for requests.cpu."
}

variable "payment_memory_request" {
  type        = string
  default     = "64Mi"
  description = "The Payment value for requests.memory."
}

variable "payment_cpu_limit" {
  type        = string
  default     = "250m"
  description = "The Payment value for limits.cpu."
}

variable "payment_memory_limit" {
  type        = string
  default     = "256Mi"
  description = "The Payment value for limits.memory."
}


############################################################
# NOTIFICATION
############################################################
variable "notification_name" {
  type        = string
  default     = "notification"
  description = "The name of the Notification application component. Changing this value will change how the application component is called in Kubernetes."
}

variable "notification_appd" {
  type        = string
  default     = "Notification"
  description = "The name of the Notification application component. Changing this value will change how the application component is called in AppDynamics."
}

variable "notification_replicas" {
  type        = number
  default     = 2
  description = "The number of replicas that should initially be deployed for the Notification component."
}

variable "notification_cpu_request" {
  type        = string
  default     = "20m"
  description = "The Notification value for requests.cpu."
}

variable "notification_memory_request" {
  type        = string
  default     = "80Mi"
  description = "The Notification value for requests.memory."
}

variable "notification_cpu_limit" {
  type        = string
  default     = "250m"
  description = "The Notification value for limits.cpu."
}

variable "notification_memory_limit" {
  type        = string
  default     = "280Mi"
  description = "The Notification value for limits.memory."
}


############################################################
# PRODREQUEST
############################################################
variable "prodrequest_name" {
  type        = string
  default     = "prodrequest"
  description = "The name of the ProdRequest application component. Changing this value will change how the application component is called in Kubernetes."
}

variable "prodrequest_appd" {
  type        = string
  default     = "ProdRequest"
  description = "The name of the ProdRequest application component. Changing this value will change how the application component is called in AppDynamics."
}

variable "prodrequest_replicas" {
  type        = number
  default     = 2
  description = "The number of replicas that should initially be deployed for the ProdRequest component."
}

variable "prodrequest_cpu_request" {
  type        = string
  default     = "20m"
  description = "The ProdRequest value for requests.cpu."
}

variable "prodrequest_memory_request" {
  type        = string
  default     = "80Mi"
  description = "The ProdRequest value for requests.memory."
}

variable "prodrequest_cpu_limit" {
  type        = string
  default     = "250m"
  description = "The ProdRequest value for limits.cpu."
}

variable "prodrequest_memory_limit" {
  type        = string
  default     = "280Mi"
  description = "The ProdRequest value for limits.memory."
}


############################################################
# ORDERPROCESSING
############################################################
variable "orderprocessing_name" {
  type        = string
  default     = "orderprocessing"
  description = "The name of the OrderProcessing application component. Changing this value will change how the application component is called in Kubernetes."
}

variable "orderprocessing_appd" {
  type        = string
  default     = "OrderProcessing"
  description = "The name of the OrderProcessing application component. Changing this value will change how the application component is called in AppDynamics."
}

variable "orderprocessing_replicas" {
  type        = number
  default     = 2
  description = "The number of replicas that should initially be deployed for the OrderProcessing component."
}

variable "orderprocessing_cpu_request" {
  type        = string
  default     = "20m"
  description = "The OrderProcessing value for requests.cpu."
}

variable "orderprocessing_memory_request" {
  type        = string
  default     = "80Mi"
  description = "The OrderProcessing value for requests.memory."
}

variable "orderprocessing_cpu_limit" {
  type        = string
  default     = "250m"
  description = "The OrderProcessing value for limits.cpu."
}

variable "orderprocessing_memory_limit" {
  type        = string
  default     = "280Mi"
  description = "The OrderProcessing value for limits.memory."
}


############################################################
# ORDER
############################################################
variable "order_name" {
  type        = string
  default     = "apiserver"
  description = "The name of the Order application component. Changing this value will change how the application component is called in Kubernetes."
}

variable "order_appd" {
  type        = string
  default     = "APIServer"
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
# ADMINFILE
############################################################
variable "adminfile_name" {
  type        = string
  default     = "adminfile"
  description = "The name of the AdminFile application component. Changing this value will change how the application component is called in various UIs."
}

variable "adminfile_replicas" {
  type        = number
  default     = 2
  description = "The number of replicas that should initially be deployed for the OrderFile component."
}

variable "adminfile_cpu_request" {
  type        = string
  default     = "20m"
  description = "The OrderFile value for requests.cpu."
}

variable "adminfile_memory_request" {
  type        = string
  default     = "32Mi"
  description = "The OrderFile value for requests.memory."
}

variable "adminfile_cpu_limit" {
  type        = string
  default     = "50m"
  description = "The OrderFile value for limits.cpu."
}

variable "adminfile_memory_limit" {
  type        = string
  default     = "32Mi"
  description = "The OrderFile value for limits.memory."
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
# ACCOUNTING
############################################################
variable "namespace" {
  type        = string
  default     = "accounting"
  description = "Namespace used for deploying the object. This namespace has to exist and is not provisioned by this submodule."
}

variable "accounting_clusterload_configurations" {
  type    = list(object({
    pod_name     = string
    pod_replicas = number
    containers   = list(object({
      name        = string
      run_type    = string
      run_scaler  = string
      run_value   = string
      cpu_request = string
      cpu_limit   = string
      mem_request = string
      mem_limit   = string
    }))
  }))
  default = [{
    pod_name = "invoicing"
    pod_replicas = 2
    containers = [
      {
      name = "webserver"
      run_type = "cpu"
      run_scaler = "CPU_PERCENT"
      run_value = "10"
      cpu_request = "240m"
      cpu_limit = "280m"
      mem_request = "100Mi"
      mem_limit = "128Mi"
      },
      {
      name = "processing"
      run_type= "memory"
      run_scaler = "MEMORY_NUM"
      run_value = "960"
      cpu_request = "50m"
      cpu_limit = "800m"
      mem_request = "1Gi"
      mem_limit = "1Gi"
      },
    ]
  },{
    pod_name = "payroll"
    pod_replicas = 2
    containers = [
      {
      name = "webserver"
      run_type = "cpu"
      run_scaler = "CPU_PERCENT"
      run_value = "95"
      cpu_request = "50m"
      cpu_limit = "100m"
      mem_request = "100Mi"
      mem_limit = "128Mi"
      },
      {
      name = "notifications"
      run_type= "memory"
      run_scaler = "MEMORY_NUM"
      run_value = "40"
      cpu_request = "200m"
      cpu_limit = "800m"
      mem_request = "500Mi"
      mem_limit = "500Mi"
      },
    ]
  }]
  description = "This is the configuration of the clusterload Deployment(s). One Deployment is created for each entry in the list. It is possible to tune the values, such as requests, limits, and utilization of each container that will be created."
}


############################################################
# PROCUREMENT PORTAL
############################################################
variable "procportal_name" {
  type        = string
  default     = "procurement-portal"
  description = "The name of the ProcurementPortal application component. Changing this value will change how the application component is called in various UIs."
}

variable "procportal_replicas" {
  type        = number
  default     = 2
  description = "The number of replicas that should initially be deployed for the ProcurementPortal component."
}

variable "procportal_cpu_request" {
  type        = string
  default     = "100m"
  description = "The ProcurementPortal value for requests.cpu."
}

variable "procportal_memory_request" {
  type        = string
  default     = "600Mi"
  description = "The ProcurementPortal value for requests.memory."
}

variable "procportal_cpu_limit" {
  type        = string
  default     = "200m"
  description = "The ProcurementPortal value for limits.cpu."
}

variable "procportal_memory_limit" {
  type        = string
  default     = "900Mi"
  description = "The ProcurementPortal value for limits.memory."
}


############################################################
# PROCUREMENT EXTERNAL
############################################################
variable "procexternal_name" {
  type        = string
  default     = "external-procurement"
  description = "The name of the ProcurementExternal application component. Changing this value will change how the application component is called in various UIs."
}

variable "procprediction_replicas" {
  type        = number
  default     = 2
  description = "The number of replicas that should initially be deployed for the ProcurementExternal component."
}

variable "procprediction_cpu_request" {
  type        = string
  default     = "100m"
  description = "The ProcurementExternal value for requests.cpu."
}

variable "procprediction_memory_request" {
  type        = string
  default     = "600Mi"
  description = "The ProcurementExternal value for requests.memory."
}

variable "procprediction_cpu_limit" {
  type        = string
  default     = "200m"
  description = "The ProcurementExternal value for limits.cpu."
}

variable "procprediction_memory_limit" {
  type        = string
  default     = "900Mi"
  description = "The ProcurementExternal value for limits.memory."
}


############################################################
# PROCUREMENT PREDICTION
############################################################
variable "procprediction_name" {
  type        = string
  default     = "prediction-service"
  description = "The name of the ProcurementPrediction application component. Changing this value will change how the application component is called in various UIs."
}

variable "procprediction_replicas" {
  type        = number
  default     = 2
  description = "The number of replicas that should initially be deployed for the ProcurementPrediction component."
}

variable "procprediction_cpu_request" {
  type        = string
  default     = "250m"
  description = "The ProcurementPrediction value for requests.cpu."
}

variable "procprediction_memory_request" {
  type        = string
  default     = "400Mi"
  description = "The ProcurementPrediction value for requests.memory."
}

variable "procprediction_cpu_limit" {
  type        = string
  default     = "500m"
  description = "The ProcurementPrediction value for limits.cpu."
}

variable "procprediction_memory_limit" {
  type        = string
  default     = "1000Mi"
  description = "The ProcurementPrediction value for limits.memory."
}


############################################################
# PROCUREMENT EDGE
############################################################
variable "procedge_name" {
  type        = string
  default     = "edge-collector"
  description = "The name of the ProcurementEdge application component. Changing this value will change how the application component is called in various UIs."
}

variable "procedge_replicas" {
  type        = number
  default     = 4
  description = "The number of replicas that should initially be deployed for the ProcurementEdge component."
}

variable "procedge_cpu_request" {
  type        = string
  default     = "100m"
  description = "The ProcurementEdge value for requests.cpu."
}

variable "procedge_memory_request" {
  type        = string
  default     = "600Mi"
  description = "The ProcurementEdge value for requests.memory."
}

variable "procedge_cpu_limit" {
  type        = string
  default     = "200m"
  description = "The ProcurementEdge value for limits.cpu."
}

variable "procedge_memory_limit" {
  type        = string
  default     = "900Mi"
  description = "The ProcurementEdge value for limits.memory."
}

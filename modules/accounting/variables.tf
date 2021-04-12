############################################################
# INPUT VARIABLES
############################################################
variable "namespace" {
  type        = string
  default     = "accounting"
  description = "Namespace used for deploying the object. This namespace has to exist and is not provisioned by this submodule."
}

variable "clusterload_configurations" {
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

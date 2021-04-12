############################################################
# REQUIRED PROVIDERS
############################################################
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
    }
  }
}


############################################################
# CREATE ACCOUNTING DEPLOYMENT
############################################################
module "clusterload" {
  source  = "3191110276/clusterload/kubernetes"
  version = "0.2.0"

  namespace = var.namespace

  clusterload_configurations = [{
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
}

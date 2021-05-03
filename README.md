# Terraform module for deploying the Cisco Kubernetes Demo application

The Cisco Kubernetes demo application consists of multiple building blocks that interact. During your setup of this application you might decide to set up one, a few, or all of the components. You can also set up different components on different clusters and connect them with each other. This documentation will first explain the high-level design of the application before diving into each sub-component and explaining the customization and adaptation options for each of them.

## High-level application design

The application consists of six main building blocks that can be seen in the image below.
![High-level application design](https://github.com/3191110276/terraform-kubernetes-cnb/blob/main/images/high_level_design.png?raw=true)

As you can see, the application has already been created with a specific use case in mind, but all components can be re-named. Thus you can adapt the application to show any use case. By just re-naming this application, it could show a finance use case, a medical use case, or anything else that you might want to demo. Each application component also equals to a namespace in Kubernetes.

The main characteristic you can change about the high-level components is the name of the namespace and whether or not the component should be deployed at all. The name change allows you to adapt the application to different scenarios. You can also decide that components you want to deploy to, for example, split the application up across multiple clusters. Below you can find an overview of the Terraform variables you can use to tune the high-level design:

| Component   | Deploy? (bool)     | Namespace (string)          |
|-------------|--------------------|-----------------------------|
| Trafficgen  | deploy_trafficgen  | trafficgen_namespace        |
| Order       | deploy_order       | order_namespace             |
| ExtPayment  | deploy_extpayment  | extpayment_namespace        |
| ExtProd     | deploy_extprod     | extprod_namespace           |
| Procurement | deploy_procurement | procurement_namespace       |
| Accounting  | deploy_accounting  | accounting_namespace        |


## Component: TrafficGen
The TrafficGen application component is used for generating user traffic to the web frontend (part of the Order application component). This simulated traffic loads the webpage and then generates multiple requests on the page. What happens can be modified in several ways to simulate certain events. You could, for example, change the client response time to simulate Internet connectivity problems. These values have not been exposed yet, but will be avaiable in a future release. Below you can find an overview of all variables you can change and their effect on the generated traffic.

| Variable                | Default                                                | Effect                                                                                |
|-------------------------|--------------------------------------------------------|---------------------------------------------------------------------------------------|
| trafficgen_app_endpoint | essential-nginx-ingress-ingress-nginx-controller.iks   | The endpoint to which all requests are sent                                           |
| trafficgen_name         | trafficgen                                             | The name of the application component in Kubernetes itself                            |
| trafficgen_replicas     | 10                                                     | Simultaneous requests that will be generated. Double the amount is created per minute |

## Component: Order
The Order application component consists of multiple sub-components that all exist in the same namespace. You can see a high-level overview of the component below.

![Order design](https://github.com/3191110276/terraform-kubernetes-cnb/blob/main/images/order_design.png?raw=true)

As you can see, there are several sub-components that all communicate with each other. To modify which components get deployed on a cluster, you can modify the variable "order_subcomponents_deployment". As an example, the definition below would deploy all subcomponents:

```terraform
{
  "nginx_ingress": true,
  "adminfile": true,
  "orderfile": true,
  "apiserver": true,
  "inventorydb": true,
  "payment": true,
  "orderprocessing": true,
  "orderqueue": true,
  "notification": true,
  "prodrequest": true,
  "production": true
  "fulfilment": true,
}
```

By default, all subcomponents will be deployed. Below you can find the documentation for each subcomponents and the variables that are available for each of them.

### Subcomponent: AdminFile
The AdminFile application subcomponent provides an HTTP web server with an admin interface. You can change the following variables to adapt this subcomponent:

| Variable                 | Default   | Effect                                                                  |
|--------------------------|-----------|-------------------------------------------------------------------------|
| adminfile_name           | adminfile | Name of AdminFile in Kubernetes                                         |
| adminfile_replicas       | 2         | Copies of the Pod                                                       |
| adminfile_cpu_request    | 20m       | CPU Request for each Pod                                                |
| adminfile_cpu_limit      | 50m       | CPU Limit for each Pod                                                  |
| adminfile_memory_request | 32Mi      | Memory Request for each Pod                                             |
| adminfile_memory_limit   | 32Mi      | Memory Limit for each Pod                                               |

### Subcomponent: OrderFile
The OrderFile application subcomponent provides an HTTP web server with an end user interface. You can change the following variables to adapt this subcomponent:

| Variable                 | Default   | Effect                                                                  |
|--------------------------|-----------|-------------------------------------------------------------------------|
| orderfile_name           | orderfile | Name of OrderFile in Kubernetes                                         |
| orderfile_replicas       | 2         | Copies of the Pod                                                       |
| orderfile_cpu_request    | 20m       | CPU Request for each Pod                                                |
| orderfile_cpu_limit      | 50m       | CPU Limit for each Pod                                                  |
| orderfile_memory_request | 32Mi      | Memory Request for each Pod                                             |
| orderfile_memory_limit   | 32Mi      | Memory Limit for each Pod                                               |

### Subcomponent: APIServer
The APIServer application subcomponent provides an HTTP API Server with serveral methods that are also implemented in the OrderFile webpage. The APIServer communicates with the InventoryDB, Payment, and OrderProcessing. You can change the following variables to adapt this subcomponent:

| Variable             | Default   | Effect                               |
|----------------------|-----------|--------------------------------------|
| order_name           | apiserver | Name of APIServer in Kubernetes      |
| order_appd           | APIServer | Name of the APIServer in AppDynamics |
| order_replicas       | 2         | Copies of the Pod                    |
| order_cpu_request    | 100m      | CPU Request for each Pod             |
| order_cpu_limit      | 400m      | CPU Limit for each Pod               |
| order_memory_request | 128Mi     | Memory Request for each Pod          |
| order_memory_limit   | 512Mi     | Memory Limit for each Pod            |

### Subcomponent: InventoryDB
The InventoryDB application subcomponent provides a MariaDB instance that is used for storing relevant information about the transactions. You can change the following variables to adapt this subcomponent:

### Subcomponent: Payment
The Payment application subcomponent provides an HTTP microservice that acts as a middleman between the APIServer and the ExtPayment application component. It can receive HTTP requests from the APIServer and forwards them to ExtPayment. You can change the following variables to adapt this subcomponent:

### Subcomponent: OrderProcessing
The OrderProcessing application subcomponent provides an HTTP microservice that acts as a middleman between the APIServer and the OrderQueue application component. It can receive HTTP requests from the APIServer and forwards them to the Orderqueue message queue. You can change the following variables to adapt this subcomponent:

### Subcomponent: OrderQueue
The OrderQueue application subcomponent provides a message queue that stores all production requests. It receives requests from OrderProcessing. The Notification and ProdRequest components then consume the message queue entries. You can change the following variables to adapt this subcomponent:

### Subcomponent: Notification
The Notification application subcomponent consumes entries from the OrderQueue message queue and then creates a notification message. You can change the following variables to adapt this subcomponent:

### Subcomponent: ProdRequest
The ProdRequest application subcomponent consumes entries from the OrderQueue message queue and then creates an HTTP request that is sent to the Production subcomponent. You can change the following variables to adapt this subcomponent:

### Subcomponent: Production
The Production application subcomponent provides an HTTP microservice that receives requests from ProdRequest, and then forwards them to ExtProd. Upon receiving a request from ExtProd in response, it forwards it as an HTTP request to Fulfilment. You can change the following variables to adapt this subcomponent:

### Subcomponent: Fulfilment
The Fulfilment application subcomponent provides an HTTP microservice that receives requests from Production. You can change the following variables to adapt this subcomponent:

## Component: ExtPayment
The ExtPayment application component represents an HTTP endpoint that can be connected to from the Order application component. Unlike Order, this component does not have any instrumentation for AppDynamics, thus it will appear like an external call, even if both components are deployed on the same cluster. This component allows for tuning some response time parameters to fake delays when processing the request. You can modify the values in the table below to change the way that ExtPayment looks and behaves.

| Variable                       | Default | Effect                                                                       |
|--------------------------------|---------|------------------------------------------------------------------------------|
| extpayment_name                | payment | Name of ExtPayment - changes how it will show up in UIs like AppDynamics.    |
| extpayment_replicas            | 2       | Copies of the Pod                                                            |
| extpayment_cpu_request         | 100m    | CPU Request for each Pod                                                     |
| extpayment_cpu_limit           | 400m    | CPU Limit for each Pod                                                       |
| extpayment_memory_request      | 128Mi   | Memory Request for each Pod                                                  |
| extpayment_memory_limit        | 512Mi   | Memory Limit for each Pod                                                    |
| extpayment_min_random_delay    | 0       | Minimum average delay for a request in milliseconds                          |
| extpayment_max_random_delay    | 1000    | Maximum average delay for a request in milliseconds                          |
| extpayment_lagspike_percentage | 0.01    | Chance of a lagspike happening per request                                   |

## Component: ExtProd
The ExtProd application component represents an external web endpoint, which receives requests from the Order application. Each successful request results in a Kubernetes Job. Once the job finishes, it will send back a request to the application component in Order. The request from Order to ExtProd, and the request from ExtProd back to Order are not directly related, and essentially represent two different transactions. If you need a component to put on a remote cluster, ExtProd is a good choice for this. You can tune the internal behavior of this component with the following Terraform variables.

| Variable               | Default | Effect                                                                |
|------------------------|---------|-----------------------------------------------------------------------|
| extprod_name           | gateway | Name of ExtProd - changes how it will show up in UIs like AppDynamics |
| extprod_replicas       | 2       | Copies of the Pod                                                     |
| extprod_cpu_request    | 100m    | CPU Request for each Pod                                              |
| extprod_cpu_limit      | 400m    | CPU Limit for each Pod                                                |
| extprod_memory_request | 128Mi   | Memory Request for each Pod                                           |
| extprod_memory_limit   | 512Mi   | Memory Limit for each Pod                                             |
| extprod_min_delay      | 0       | Minimum average delay for a request in milliseconds                   |
| extprod_max_delay      | 1000    | Maximum average delay for a request in milliseconds                   |
| extprod_job_min_delay  | 240     | Duration of the Kubernetes Job created by ExtProd                     |
| extprod_job_max_delay  | 360     | Duration of the Kubernetes Job created by ExtProd                     |

## Component: Accounting
The Accounting application component represents Deployments that are created with the purpose of showing oversized or undersized Pods. These components do not have any connectivity between them or any requests coming in or going out. They are just statically set to a certain CPU and/or memory usage, which can then be analyzed using monitoring tools like AppDynamics or Intersight Workload Optimizer. The Pods defined in this component are all defined dynamically through a variable called "accounting_clusterload_configurations". Changing this variable allows you to rename the Pods, to create new Pods, and to change their characteristics.

## Component: Procurement
The Procurement application component consists of multiple sub-components that all exist in the same namespace. You can see a high-level overview of the component below.

![Procurement design](https://github.com/3191110276/terraform-kubernetes-cnb/blob/main/images/procurement_design.png?raw=true)

As you can see, there are several sub-components that all communicate with each other. The ResponseSvc is used by multiple components as an external service which is not instrumented by AppDynamics, and thus looks like an outside call. If you want to split this application up across multiple clusters, you could put EdgeCollector components on different clusters and then add the remainder of the application on one central cluster. To modify which components get deployed on a cluster, you can modify the variable "procurement_subcomponents_deployment". As an example, the definition below would deploy all subcomponents:

```terraform
{
  "procurement_load": true,
  "edge_collector": true,
  "edge_aggregator": true,
  "procurement_portal": true,
  "prediction": true,
  "external_procurement": true,
  "responsesvc": true
}
```

By default, all subcomponents will be deployed. Below you can find the documentation for each subcomponents and the variables that are available for each of them. The components allow you to change their name, their replicas and their CPU/memory request/limit.

### Subcomponent: ProcurementLoad
The ProcurementLoad application subcomponent creates artificial load for the Procurement components. You can change the following variables to adapt this subcomponent:

| Variable                | Default  | Effect                      |
|-------------------------|----------|-----------------------------|
| procload_name           | app-load | Name of ProcLoad            |
| procload_replicas       | 4        | Copies of the Pod           |
| procload_cpu_request    | 100m     | CPU Request for each Pod    |
| procload_cpu_limit      | 200m     | CPU Limit for each Pod      |
| procload_memory_request | 600Mi    | Memory Request for each Pod |
| procload_memory_limit   | 900Mi    | Memory Limit for each Pod   |

### Subcomponent: EdgeCollector
The EdgeCollector application subcomponent creates HTTP requests to the ResponseSvc, and then creates HTTP requests to the EdgeAggregator. You can change the following variables to adapt this subcomponent:

| Variable                | Default        | Effect                                                                      |
|-------------------------|----------------|-----------------------------------------------------------------------------|
| procedge_name           | edge-collector | Name of EdgeCollector - changes how it will show up in UIs like AppDynamics |
| procedge_replicas       | 4              | Copies of the Pod                                                           |
| procedge_cpu_request    | 100m           | CPU Request for each Pod                                                    |
| procedge_cpu_limit      | 200m           | CPU Limit for each Pod                                                      |
| procedge_memory_request | 600Mi          | Memory Request for each Pod                                                 |
| procedge_memory_limit   | 900Mi          | Memory Limit for each Pod                                                   |

### Subcomponent: EdgeAggregator
The EdgeAggregator application subcomponent receives HTTP requests from the EdgeCollector, and then creates HTTP requests to the ProcurementPortal. You can change the following variables to adapt this subcomponent:

| Variable                   | Default         | Effect                                                                       |
|----------------------------|-----------------|------------------------------------------------------------------------------|
| procedgeagg_name           | edge-aggregator | Name of EdgeAggregator - changes how it will show up in UIs like AppDynamics |
| procedgeagg_replicas       | 2               | Copies of the Pod                                                            |
| procedgeagg_cpu_request    | 100m            | CPU Request for each Pod                                                     |
| procedgeagg_cpu_limit      | 200m            | CPU Limit for each Pod                                                       |
| procedgeagg_memory_request | 600Mi           | Memory Request for each Pod                                                  |
| procedgeagg_memory_limit   | 900Mi           | Memory Limit for each Pod                                                    |

### Subcomponent: ProcurementPortal
The ProcurementPortal application subcomponent receives HTTP requests from the EdgeAggreator, and creates HTTP requests to the Prediction and ExternalProcurement components. You can change the following variables to adapt this subcomponent:

| Variable                  | Default            | Effect                                                                          |
|---------------------------|--------------------|---------------------------------------------------------------------------------|
| procportal_name           | procurement-portal | Name of ProcurementPortal - changes how it will show up in UIs like AppDynamics |
| procportal_replicas       | 2                  | Copies of the Pod                                                               |
| procportal_cpu_request    | 100m               | CPU Request for each Pod                                                        |
| procportal_cpu_limit      | 200m               | CPU Limit for each Pod                                                          |
| procportal_memory_request | 600Mi              | Memory Request for each Pod                                                     |
| procportal_memory_limit   | 900Mi              | Memory Limit for each Pod                                                       |

### Subcomponent: Prediction
The Prediction application subcomponent receives HTTP requests from the ProcurementPortal. You can change the following variables to adapt this subcomponent:

| Variable                      | Default            | Effect                                                                   |
|-------------------------------|--------------------|--------------------------------------------------------------------------|
| procprediction_name           | prediction-service | Name of Prediction - changes how it will show up in UIs like AppDynamics |
| procprediction_replicas       | 2                  | Copies of the Pod                                                        |
| procprediction_cpu_request    | 250m               | CPU Request for each Pod                                                 |
| procprediction_cpu_limit      | 500m               | CPU Limit for each Pod                                                   |
| procprediction_memory_request | 400Mi              | Memory Request for each Pod                                              |
| procprediction_memory_limit   | 1000Mi             | Memory Limit for each Pod                                                |

### Subcomponent: ExternalProcurement
The ExternalProcurement application subcomponent receives HTTP requests from the ProcurementPortal, and creates HTTP requests to the ProcurementPortal. You can change the following variables to adapt this subcomponent:

| Variable                    | Default              | Effect                                                                            |
|-----------------------------|----------------------|-----------------------------------------------------------------------------------|
| procexternal_name           | external-procurement | Name of ExternalProcurement - changes how it will show up in UIs like AppDynamics |
| procexternal_replicas       | 2                    | Copies of the Pod                                                                 |
| procexternal_cpu_request    | 100m                 | CPU Request for each Pod                                                          |
| procexternal_cpu_limit      | 200m                 | CPU Limit for each Pod                                                            |
| procexternal_memory_request | 600Mi                | Memory Request for each Pod                                                       |
| procexternal_memory_limit   | 900Mi                | Memory Limit for each Pod                                                         |

### Subcomponent: ResponseSvc
The ResponseSvc application subcomponent allows for various external calls from the Procurement components. You should not need to modify this component.

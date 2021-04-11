############################################################
# REQUIRED PROVIDERS
############################################################
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
    }
    kubernetes-alpha = {
      source  = "hashicorp/kubernetes-alpha"
      version = ">= 0.3.2"
    }
  }
}


############################################################
# CREATE INVENTORYDB
############################################################
resource "kubernetes_manifest" "customresourcedefinition_monitors_mariadb_persistentsys" {
  provider = kubernetes-alpha
  
  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1beta1"
    "kind" = "CustomResourceDefinition"
    "metadata" = {
      "name" = "monitors.mariadb.persistentsys"
    }
    "spec" = {
      "group" = "mariadb.persistentsys"
      "names" = {
        "kind" = "Monitor"
        "listKind" = "MonitorList"
        "plural" = "monitors"
        "singular" = "monitor"
      }
      "scope" = "Namespaced"
      "subresources" = {
        "status" = {}
      }
      "validation" = {
        "openAPIV3Schema" = {
          "description" = "Monitor is the Schema for the monitors API"
          "properties" = {
            "apiVersion" = {
              "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
              "type" = "string"
            }
            "kind" = {
              "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
              "type" = "string"
            }
            "metadata" = {
              "type" = "object"
            }
            "spec" = {
              "description" = "MonitorSpec defines the desired state of Monitor"
              "properties" = {
                "dataSourceName" = {
                  "description" = "Database source name"
                  "type" = "string"
                }
                "image" = {
                  "description" = "Image name with version"
                  "type" = "string"
                }
                "size" = {
                  "description" = "INSERT ADDITIONAL SPEC FIELDS - desired state of cluster Important: Run \"operator-sdk generate k8s\" to regenerate code after modifying this file Add custom validation using kubebuilder tags: https://book-v1.book.kubebuilder.io/beyond_basics/generating_crd.html Size is the size of the deployment"
                  "format" = "int32"
                  "type" = "integer"
                }
              }
              "required" = [
                "dataSourceName",
                "image",
                "size",
              ]
              "type" = "object"
            }
            "status" = {
              "description" = "MonitorStatus defines the observed state of Monitor"
              "type" = "object"
            }
          }
          "type" = "object"
        }
      }
      "version" = "v1alpha1"
      "versions" = [
        {
          "name" = "v1alpha1"
          "served" = true
          "storage" = true
        },
      ]
    }
  }
}


resource "kubernetes_manifest" "customresourcedefinition_mariadbs_mariadb_persistentsys" {
  provider = kubernetes-alpha
  
  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1beta1"
    "kind" = "CustomResourceDefinition"
    "metadata" = {
      "name" = "mariadbs.mariadb.persistentsys"
    }
    "spec" = {
      "group" = "mariadb.persistentsys"
      "names" = {
        "kind" = "MariaDB"
        "listKind" = "MariaDBList"
        "plural" = "mariadbs"
        "singular" = "mariadb"
      }
      "scope" = "Namespaced"
      "subresources" = {
        "status" = {}
      }
      "validation" = {
        "openAPIV3Schema" = {
          "description" = "MariaDB is the Schema for the mariadbs API"
          "properties" = {
            "apiVersion" = {
              "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
              "type" = "string"
            }
            "kind" = {
              "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
              "type" = "string"
            }
            "metadata" = {
              "type" = "object"
            }
            "spec" = {
              "description" = "MariaDBSpec defines the desired state of MariaDB"
              "properties" = {
                "dataStoragePath" = {
                  "description" = "Database storage Path"
                  "type" = "string"
                }
                "dataStorageSize" = {
                  "description" = "Database storage Size (Ex. 1Gi, 100Mi)"
                  "type" = "string"
                }
                "database" = {
                  "description" = "New Database name"
                  "type" = "string"
                }
                "image" = {
                  "description" = "Image name with version"
                  "type" = "string"
                }
                "password" = {
                  "description" = "Database additional user password (base64 encoded)"
                  "type" = "string"
                }
                "port" = {
                  "description" = "Port number exposed for Database service"
                  "format" = "int32"
                  "type" = "integer"
                }
                "rootpwd" = {
                  "description" = "Root user password"
                  "type" = "string"
                }
                "size" = {
                  "description" = "Size is the size of the deployment"
                  "format" = "int32"
                  "type" = "integer"
                }
                "username" = {
                  "description" = "Database additional user details (base64 encoded)"
                  "type" = "string"
                }
              }
              "required" = [
                "dataStoragePath",
                "dataStorageSize",
                "database",
                "image",
                "password",
                "port",
                "rootpwd",
                "size",
                "username",
              ]
              "type" = "object"
            }
            "status" = {
              "description" = "MariaDBStatus defines the observed state of MariaDB"
              "properties" = {
                "nodes" = {
                  "description" = "Nodes are the names of the pods"
                  "items" = {
                    "type" = "string"
                  }
                  "type" = "array"
                }
              }
              "type" = "object"
            }
          }
          "type" = "object"
        }
      }
      "version" = "v1alpha1"
      "versions" = [
        {
          "name" = "v1alpha1"
          "served" = true
          "storage" = true
        },
      ]
    }
  }
}


resource "kubernetes_manifest" "customresourcedefinition_backups_mariadb_persistentsys" {
  provider = kubernetes-alpha
  
  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1beta1"
    "kind" = "CustomResourceDefinition"
    "metadata" = {
      "name" = "backups.mariadb.persistentsys"
    }
    "spec" = {
      "group" = "mariadb.persistentsys"
      "names" = {
        "kind" = "Backup"
        "listKind" = "BackupList"
        "plural" = "backups"
        "singular" = "backup"
      }
      "scope" = "Namespaced"
      "subresources" = {
        "status" = {}
      }
      "validation" = {
        "openAPIV3Schema" = {
          "description" = "Backup is the Schema for the backups API"
          "properties" = {
            "apiVersion" = {
              "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
              "type" = "string"
            }
            "kind" = {
              "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
              "type" = "string"
            }
            "metadata" = {
              "type" = "object"
            }
            "spec" = {
              "description" = "BackupSpec defines the desired state of Backup"
              "properties" = {
                "backupPath" = {
                  "description" = "Backup Path"
                  "type" = "string"
                }
                "backupSize" = {
                  "description" = "Backup Size (Ex. 1Gi, 100Mi)"
                  "type" = "string"
                }
                "schedule" = {
                  "description" = "Schedule period for the CronJob. This spec allow you setup the backup frequency Default: \"0 0 * * *\" # daily at 00:00"
                  "type" = "string"
                }
              }
              "required" = [
                "backupPath",
                "backupSize",
              ]
              "type" = "object"
            }
            "status" = {
              "description" = "BackupStatus defines the observed state of Backup"
              "type" = "object"
            }
          }
          "type" = "object"
        }
      }
      "version" = "v1alpha1"
      "versions" = [
        {
          "name" = "v1alpha1"
          "served" = true
          "storage" = true
        },
      ]
    }
  }
}


resource "kubernetes_service_account" "inventorydb" {
  metadata {
    name      = "mariadb-operator"
    namespace = var.namespace
  }
}


resource "kubernetes_role" "inventorydb" {
  metadata {
    name      = "mariadb-operator"
    namespace = var.namespace
  }

  rule {
    api_groups     = [""]
    resources      = ["pods", "services", "services/finalizers", "endpoints", "persistentvolumeclaims", "events", "configmaps", "secrets"]
    verbs          = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }
  
  rule {
    api_groups     = ["apps"]
    resources      = ["deployments", "daemonsets", "replicasets", "statefulsets"]
    verbs          = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }
  
  rule {
    api_groups     = ["monitoring.coreos.com"]
    resources      = ["servicemonitors"]
    verbs          = ["get", "create"]
  }

  rule {
    api_groups     = ["apps"]
    resources      = ["deployments/finalizers"]
    resource_names = ["mariadb-operator"]
    verbs          = ["update"]
  }
  
  rule {
    api_groups     = [""]
    resources      = ["pods"]
    verbs          = ["get"]
  }

  rule {
    api_groups     = ["apps"]
    resources      = ["replicasets", "deployments"]
    verbs          = ["get"]
  }
  
  rule {
    api_groups     = ["mariadb.persistentsys"]
    resources      = ["*", "backups"]
    verbs          = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }
  
  rule {
    api_groups     = ["batch"]
    resources      = ["cronjobs", "jobs"]
    verbs          = ["create", "delete", "get", "list", "watch", "update"]
  }
}


resource "kubernetes_role_binding" "inventorydb" {
  depends_on = [kubernetes_service_account.inventorydb, kubernetes_role.inventorydb]
  
  metadata {
    name      = "mariadb-operator"
    namespace = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "mariadb-operator"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "mariadb-operator"
  }
}


resource "kubernetes_cluster_role" "inventorydb" {
  metadata {
    name      = "mariadb-operator-cl-role"
    namespace = var.namespace
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "persistentvolumes", "namespaces"]
    verbs      = ["list", "watch", "get", "create", "delete"]
  }
  
  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
    verbs      = ["list", "watch", "get", "create", "delete"]
  }
  
  rule {
    api_groups = ["monitoring.coreos.com"]
    resources  = ["alertmanagers", "prometheuses", "prometheuses/finalizers", "servicemonitors"]
    verbs      = ["*"]
  }
}


resource "kubernetes_cluster_role_binding" "inventorydb" {
  depends_on = [kubernetes_service_account.inventorydb, kubernetes_cluster_role.inventorydb]
  
  metadata {
    name = "mariadb-operator-cl-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "mariadb-operator-cl-role"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "mariadb-operator"
    namespace = var.namespace
  }
}


resource "kubernetes_persistent_volume_claim" "inventorydb" {
  metadata {
    name      = "mariadb-pv-claim"
    namespace = var.namespace
  }
  spec {
    storage_class_name = "standard"
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "4Gi"
      }
    }
  }
}


apiVersion: apps/v1
kind: Deployment
metadata:
  name: mariadb-operator
  namespace: {{ .Release.Namespace }}
spec:
  replicas: 1
  selector:
    matchLabels:
      name: mariadb-operator
  template:
    metadata:
      labels:
        name: mariadb-operator
    spec:
      serviceAccountName: mariadb-operator
      containers:
        - name: mariadb-operator
          # Replace this with the built image name
          image: quay.io/manojdhanorkar/mariadb-operator:v0.0.4
          resources:
            requests:
              cpu: 10m
              memory: 32Mi
            limits:
              cpu: 50m
              memory: 32Mi
          command:
          - mariadb-operator
          imagePullPolicy: Always
          env:
            - name: WATCH_NAMESPACE
              value: {{ .Release.Namespace }}
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: OPERATOR_NAME
              value: "mariadb-operator"
---
apiVersion: mariadb.persistentsys/v1alpha1
kind: MariaDB
metadata:
  name: {{ .Values.appname }}-{{ .Values.inventorydb_name }}
  namespace: {{ .Release.Namespace }}
spec:
  # Keep this parameter value unchanged.
  size: 1
  
  # Root user password
  rootpwd: root

  # New Database name
  database: default
  # Database additional user details (base64 encoded)
  username: db-user
  password: db-user

  # Image name with version
  image: {{ .Values.registry }}/inventorydb-{{ .Values.inventorydb_tech }}:{{ .Values.inventorydb_version }}

  # Database storage Path
  dataStoragePath: "/mnt/data" 

  # Database storage Size (Ex. 1Gi, 100Mi)
  dataStorageSize: "2Gi"

  # Port number exposed for Database service
  port: 30999

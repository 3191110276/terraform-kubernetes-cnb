############################################################
# REQUIRED PROVIDERS
############################################################
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.2"
    }
  }
}


############################################################
# CREATE INVENTORYDB
############################################################
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


resource "kubernetes_deployment" "inventorydb" {
  depends_on = [kubernetes_persistent_volume_claim.inventorydb, kubernetes_cluster_role_binding.inventorydb, kubernetes_manifest.customresourcedefinition_backups_mariadb_persistentsys, kubernetes_manifest.customresourcedefinition_mariadbs_mariadb_persistentsys ,kubernetes_manifest.customresourcedefinition_monitors_mariadb_persistentsys]
  
  metadata {
    name      = "mariadb-operator"
    namespace = var.namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "mariadb-operator"
      }
    }

    template {
      metadata {
        labels = {
          name = "mariadb-operator"
        }
      }

      spec {
        service_account_name = "mariadb-operator"
        
        container {
          image = "quay.io/manojdhanorkar/mariadb-operator:v0.0.4"
          name  = "mariadb-operator"

          command = ["mariadb-operator"]
          
          env {
            name  = "WATCH_NAMESPACE"
            value = var.namespace
          }
          
          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }
          
          env {
            name  = "OPERATOR_NAME"
            value = "mariadb-operator"
          }
          
          resources {
            limits = {
              cpu    = "50m"
              memory = "32Mi"
            }
            requests = {
              cpu    = "10m"
              memory = "32Mi"
            }
          }
        }
      }
    }
  }
}


resource "helm_release" "inventorydb" {
  depends_on = [kubernetes_deployment.inventorydb]
  
  name       = "inventorydb"

  chart      = "${path.module}/helm/"

  namespace  = var.namespace

  set {
    name  = "inventorydb_name"
    value = var.inventorydb_name
  }
  
  set {
    name  = "registry"
    value = var.registry
  }
  
  set {
    name  = "inventorydb_tech"
    value = var.inventorydb_tech
  }
  
  set {
    name  = "inventorydb_version"
    value = var.inventorydb_version
  }
}

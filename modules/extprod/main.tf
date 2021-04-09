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
# CREATE EXTPROD
############################################################
resource "kubernetes_config_map" "extprod" {
  metadata {
    name      = "customization"
    namespace = var.namespace
  }

  data = {
    MIN_RANDOM     = var.min_delay
    MAX_RANDOM     = var.max_delay
    JOB_MIN        = var.job_min_delay
    JOB_MAX        = var.job_max_delay
    PRODUCTION_SVC = var.production_svc
    NAMESPACE      = var.namespace
  }
}


resource "kubernetes_service_account" "extprod" {
  metadata {
    name      = "factory"
    namespace = var.namespace
  }
}


resource "kubernetes_role" "extprod" {
  metadata {
    name      = "factory"
    namespace = var.namespace
  }

  rule {
    api_groups     = [""]
    resources      = ["pods"]
    verbs          = ["get", "list", "delete"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs"]
    verbs      = ["get", "list", "create", "delete"]
  }
}


resource "kubernetes_role_binding" "extprod" {
  depends_on = [kubernetes_service_account.extprod, kubernetes_role.extprod]
  
  metadata {
    name      = "factory"
    namespace = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "factory"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "factory"
    namespace = var.namespace
  }
}


resource "kubernetes_service" "extprod" {
  metadata {
    name      = var.extprod_name
    namespace = var.namespace
    
    labels = {
      tier = var.extprod_name
    }
  }
  spec {
    type = "ClusterIP"
    
    selector = {
      tier = var.extprod_name
    }
    
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }
  }
}




apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    tier: {{ .Values.name }}
  name: {{ .Values.name }}
  namespace: {{ .Release.Namespace }}
spec:
  replicas: {{ .Values.replicas }}
  selector:
    matchLabels:
      tier: {{ .Values.name }}
  strategy: {}
  template:
    metadata:
      labels:
        tier: {{ .Values.name }}
    spec:
      serviceAccountName: factory
#      securityContext:
#        runAsUser: 10000
#        runAsGroup: 20000
#        fsGroup: 30000
      containers:
      - name: order
        image: {{ .Values.registry }}/extprod-{{ .Values.tech }}:{{ .Values.version }}
        imagePullPolicy: Always
#        securityContext:
#          runAsUser: 10001
#          allowPrivilegeEscalation: false
        volumeMounts:
        - name: customization
          mountPath: /etc/customization
        ports:
        - name: http
          containerPort: 80
          protocol: TCP
#        - name: https
#          containerPort: 443
#          protocol: TCP
        startupProbe:
          periodSeconds: 5
          failureThreshold: 40
          httpGet:
            path: /healthz
            port: http
        livenessProbe:
          initialDelaySeconds: 5
          periodSeconds: 2
          failureThreshold: 4
          httpGet:
            path: /healthz
            port: http
      volumes:
      - name: customization
        configMap:
          name: customization

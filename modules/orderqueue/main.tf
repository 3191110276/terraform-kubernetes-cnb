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
# CREATE ORDERQUEUE DEPLOYMENT
############################################################
resource "kubernetes_service" "example" {
  metadata {
    name = "${var.app_name}-${var.initqueue_name}-rabbitmq-headless"
    namespace = var.namespace
  }
  spec {
    selector = {
      tier = var.oderqueue_name
    }
    port {
      name        = "epmd"
      port        = 4369
      target_port = "epmd"
    }

    port {
      name        = "amqp"
      port        = 5672
      target_port = "amqp"
    }

    port {
      name        = "dist"
      port        = 25672
      target_port = "dist"
    }

    port {
      name        = "http-stats"
      port        = 15672
      target_port = "http-stats"
    }

    type = "ClusterIP"
    cluster_ip = "None"
  }
}


resource "kubernetes_service" "example" {
  metadata {
    name = "${var.app_name}-${var.initqueue_name}-rabbitmq"
    namespace = var.namespace
  }
  spec {
    selector = {
      tier = var.oderqueue_name
    }
    port {
      name        = "epmd"
      port        = 4369
      target_port = "epmd"
    }

    port {
      name        = "amqp"
      port        = 5672
      target_port = "amqp"
    }

    port {
      name        = "dist"
      port        = 25672
      target_port = "dist"
    }

    port {
      name        = "http-stats"
      port        = 15672
      target_port = "http-stats"
    }

    type = "ClusterIP"
  }
}


resource "kubernetes_pod_disruption_budget" "orderqueue" {
  metadata {
    name      = "${var.app_name}-${var.initqueue_name}-rabbitmq"
    namespace = var.namespace
  }
  spec {
    min_available = "1"
    selector {
      match_labels = {
        test = var.initqueue_name
      }
    }
  }
}


resource "kubernetes_secret" "orderqueue" {
  metadata {
    name      = "${var.app_name}-${var.initqueue_name}-rabbitmq"
    namespace = var.namespace
  }

  data = {
    "rabbitmq-password" = "Z3Vlc3QK"
    "rabbitmq-erlang-cookie" = "OWU2SE1ZMTRwa2NMTVZIQjhiUnlmNzFPempwSnBRSDE="
  }

  type = "Opqaue"
}


resource "kubernetes_service_account" "orderqueue" {
  depends_on = [kubernetes_secret.orderqueue]
  
  metadata {
    name      = "${var.app_name}-${var.initqueue_name}-rabbitmq"
    namespace = var.namespace
  }
  secret {
    name = "${var.app_name}-${var.initqueue_name}-rabbitmq"
  }
}


resource "kubernetes_role" "orderqueue" {
  metadata {
    name      = "${var.app_name}-${var.initqueue_name}-rabbitmq-endpoint-reader"
    namespace = var.namespace
  }

  rule {
    api_groups     = [""]
    resources      = ["endpoints"]
    verbs          = ["get"]
  }
  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create"]
  }
}


resource "kubernetes_role_binding" "orderqueue" {
  depends_on = [kubernetes_service_account.orderqueue, kubernetes_role.orderqueue]
  
  metadata {
    name      = "${var.app_name}-${var.initqueue_name}-rabbitmq-endpoint-reader"
    namespace = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "${var.app_name}-${var.initqueue_name}-rabbitmq-endpoint-reader"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "${var.app_name}-${var.initqueue_name}-rabbitmq"
  }
}


resource "kubernetes_config_map" "orderqueue" {
  metadata {
    name      = "${var.app_name}-${var.initqueue_name}-rabbitmq-config"
    namespace = var.namespace
  }

  data = {
    "rabbitmq.conf" = <<EOT
      ## Username and password
      default_user = guest
      default_pass = guest
      ## Clustering
      cluster_formation.peer_discovery_backend  = rabbit_peer_discovery_k8s
      cluster_formation.k8s.host = kubernetes.default.svc.cluster.local
      cluster_formation.node_cleanup.interval = 10
      cluster_formation.node_cleanup.only_log_warning = true
      cluster_partition_handling = autoheal
      # queue master locator
      queue_master_locator = min-masters
      # enable guest user
      loopback_users.guest = false
    EOT
  }
}



---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ .Values.appname }}-{{ .Values.initqueue_name }}-rabbitmq
  namespace: {{ .Release.Namespace }}
spec:
  serviceName: {{ .Values.appname }}-{{ .Values.initqueue_name }}-rabbitmq-headless
  podManagementPolicy: OrderedReady
  replicas: 3
  updateStrategy:
    type: RollingUpdate
  selector:
    matchLabels:
      tier: {{ .Values.initqueue_name }}
  template:
    metadata:
      labels:
        tier: {{ .Values.initqueue_name }}
      annotations:
        checksum/config: 0a4e272ea944acede38be298ecdf4ce8b4a2b83f32c2015e815c4ee1d4c78162
        checksum/secret: cdf4233d6b9f1dab011c2fd778cf07f09c0565cdf595f41c2ddb275baad49e5c
    spec:
      
      serviceAccountName: {{ .Values.appname }}-{{ .Values.initqueue_name }}-rabbitmq
      affinity:
        podAffinity:
          
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
            - podAffinityTerm:
                labelSelector:
                  matchLabels:
                    tier: {{ .Values.initqueue_name }}
                namespaces:
                  - {{ .Release.Namespace }}
                topologyKey: kubernetes.io/hostname
              weight: 1
        nodeAffinity:
          
      securityContext:
        fsGroup: 1001
        runAsUser: 1001
      terminationGracePeriodSeconds: 120
      containers:
        - name: rabbitmq
          image: docker.io/bitnami/rabbitmq:3.8.9-debian-10-r64
          imagePullPolicy: "IfNotPresent"
          env:
            - name: BITNAMI_DEBUG
              value: "false"
            - name: MY_POD_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.podIP
            - name: MY_POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: MY_POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
            - name: K8S_SERVICE_NAME
              value: "{{ .Values.appname }}-{{ .Values.initqueue_name }}-rabbitmq-headless"
            - name: K8S_ADDRESS_TYPE
              value: hostname
            - name: RABBITMQ_FORCE_BOOT
              value: "no"
            - name: RABBITMQ_NODE_NAME
              value: "rabbit@$(MY_POD_NAME).$(K8S_SERVICE_NAME).$(MY_POD_NAMESPACE).svc.cluster.local"
            - name: K8S_HOSTNAME_SUFFIX
              value: ".$(K8S_SERVICE_NAME).$(MY_POD_NAMESPACE).svc.cluster.local"
            - name: RABBITMQ_MNESIA_DIR
              value: "/bitnami/rabbitmq/mnesia/$(RABBITMQ_NODE_NAME)"
            - name: RABBITMQ_LDAP_ENABLE
              value: "no"
            - name: RABBITMQ_LOGS
              value: "-"
            - name: RABBITMQ_ULIMIT_NOFILES
              value: "65536"
            - name: RABBITMQ_USE_LONGNAME
              value: "true"
            - name: RABBITMQ_ERL_COOKIE
              valueFrom:
                secretKeyRef:
                  name: {{ .Values.appname }}-{{ .Values.initqueue_name }}-rabbitmq
                  key: rabbitmq-erlang-cookie
            - name: RABBITMQ_USERNAME
#              value: "user"
              value: "guest"
            - name: RABBITMQ_PASSWORD
              value: "guest"
#              valueFrom:
#                secretKeyRef:
#                  name: {{ .Values.appname }}-{{ .Values.initqueue_name }}-rabbitmq
#                  key: rabbitmq-password
            - name: RABBITMQ_PLUGINS
              value: "rabbitmq_management, rabbitmq_peer_discovery_k8s, rabbitmq_auth_backend_ldap"
          ports:
            - name: amqp
              containerPort: 5672
            - name: dist
              containerPort: 25672
            - name: stats
              containerPort: 15672
            - name: epmd
              containerPort: 4369
          livenessProbe:
            exec:
              command:
                - /bin/bash
                - -ec
                - rabbitmq-diagnostics -q ping
            initialDelaySeconds: 120
            periodSeconds: 30
            timeoutSeconds: 20
            successThreshold: 1
            failureThreshold: 3
          readinessProbe:
            exec:
              command:
                - /bin/bash
                - -ec
                - rabbitmq-diagnostics -q check_running && rabbitmq-diagnostics -q check_local_alarms
            initialDelaySeconds: 10
            periodSeconds: 30
            timeoutSeconds: 20
            successThreshold: 1
            failureThreshold: 3
          resources:
            limits:
              cpu: 1000m
              memory: 2Gi
            requests:
              cpu: 1000m
              memory: 2Gi
          lifecycle:
            preStop:
              exec:
                command:
                  - /bin/bash
                  - -ec
                  - |
                    if [[ -f /opt/bitnami/scripts/rabbitmq/nodeshutdown.sh ]]; then
                        /opt/bitnami/scripts/rabbitmq/nodeshutdown.sh -t "120" -d  "false"
                    else
                        rabbitmqctl stop_app
                    fi
          volumeMounts:
            - name: configuration
              mountPath: /bitnami/rabbitmq/conf
            - name: data
              mountPath: /bitnami/rabbitmq/mnesia
      volumes:
        - name: configuration
          configMap:
            name: {{ .Values.appname }}-{{ .Values.initqueue_name }}-rabbitmq-config
            items:
              - key: rabbitmq.conf
                path: rabbitmq.conf
  volumeClaimTemplates:
    - metadata:
        name: data
        labels:
          app.kubernetes.io/name: rabbitmq
          app.kubernetes.io/instance: {{ .Values.appname }}-{{ .Values.initqueue_name }}
      spec:
        accessModes:
          - "ReadWriteOnce"
        resources:
          requests:
            storage: "8Gi"

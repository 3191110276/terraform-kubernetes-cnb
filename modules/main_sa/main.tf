



apiVersion: v1
kind: ServiceAccount
metadata:
  name: no-priv
  namespace: {{ .Release.Namespace }}
automountServiceAccountToken: false

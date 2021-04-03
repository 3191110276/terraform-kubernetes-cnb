############################################################
# CREATE MAIN SERVICE ACCOUNT
############################################################
resource "kubernetes_service_account" "no-priv" {
  metadata {
    name      = "no-priv"
    namespace = var.namespace
  }
  
  automount_service_account_token = false
}

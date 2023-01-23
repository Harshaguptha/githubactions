

resource "null_resource" "open-policy-agent" {
  count      = var.opa_gatekeeper == true ? 1 : 0

  # this will make a null_resource always run
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    interpreter = ["bash"]
    command     = "${var.script_path}/open-policy-agent.sh"

    environment = {
      //********Common Variables
      CLOUD_INDICATOR      = "${var.cloud_indicator}"
      LOGIN_ACCOUNT        = var.cloud_indicator == "gke" ? var.gke_service_account : var.client_id   //GKE: Service Account       AKS: Client ID
      LOGIN_KEY            = var.cloud_indicator == "gke" ? var.gke_secrets : var.client_secret       //GKE: SA Secrets JSON file  AKS: Client Secrets
      CLUSTER_NAME         = "${var.cluster_name}"
      REGION_NAME          = "${var.region_name}"
      ENVIRONMENT          = "${var.environment}"

      //********AKS Specific Variables
      AKS_SUBSCRIPTION_ID  = "${var.aks_subscription_id}"
      AKS_TENANT_ID        = "${var.aks_tenant_id}"
      AKS_RESOURCE_GROUP   = "${var.aks_resource_group_name}"

      //********GKE Specific Variables
      GKE_PROJECT_ID       = "${var.gke_project_id}"

      //********Application Variables
      INSTALL_OPA_GATEKEEPER = "${var.opa_gatekeeper}"
      APPLY_OPA_GATEKEEPER_POLICY  = "${var.opa_gatekeeper_policy}"
      DISABLE_VALIDATING_WEBHOOK = "${var.opa_disable_validating_webhook}"
      OPA_VERSION         = "${var.opa_version}"
    }
  }
}

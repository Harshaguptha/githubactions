//********** Common Variables
variable "cloud_indicator" {
  description = "The variable indicator to identify cloud platform AKS/GKE used"
  default = "aks"
}

variable "region_name"  {}

variable "login_account" {
  description = "The variable indicates Login Service Account. GKE: Service Account AKS: Client ID/ User ID"
  default = ""
}

variable "login_key" {
  description = "The variable indicates Login Credentials.  GKE: JSON credentials file path AKS: Client Secrets"
  default = ""
}

variable "cluster_name" {}

variable "helm_chart_path" {
  description = "The variable indicates local helm chart path"
  default = "./helm-chart-repo"
}

variable "environment" {}

variable "script_path" {
  default = "."
}

//********** AKS Specific Variables
variable "aks_tenant_id" {
  default = "b7f604a0-00a9-4188-9248-42f3a5aac2e9"
}

variable "aks_subscription_id" {
  description = "The variable indicates subscription/project in cloud. GKE: Project Name, AKS: Subscription ID/Name"
  default = ""
}

variable "aks_resource_group_name" {
  default = ""
}

variable "client_id" {
  default = ""
}
variable "client_secret" {
  default = ""
}

//********** GKE Specific Variables
variable "gke_project_id" {
  description = "The variable indicates subscription/project in cloud. GKE: Project Name, AKS: Subscription ID/Name"
  default = ""
}

variable "gke_service_account" {
  default = ""
}
variable "gke_secrets" {
  default = "gke_secrets_file"
}

//**********Application Variables
variable "opa_gatekeeper" {
  description = "The variable enables the installation of opa gatekeeper on the cluster provisioning"
  default     = true
}

variable "opa_gatekeeper_policy" {
  description = "The variable enables the applying of opa gatekeeper policy on the cluster provisioning"
  default     = true
}

variable "opa_disable_validating_webhook" {
  description = "The variable enables the opa_disable_validating_webhook on the cluster provisioning"
  default     = false
}

variable "opa_version" {
  description = "The variable enables the opa_version to be deployed on the cluster provisioning"
  default     = "v3.9.0"
}

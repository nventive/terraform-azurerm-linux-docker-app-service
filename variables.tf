variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to deploy the App Service to."
}

variable "resource_group_location" {
  type        = string
  description = "Location of the resource group to deploy the App Service to."
}

variable "app_settings" {
  type        = map(string)
  default     = {}
  description = "App Settings or environment variables to apply."
}

variable "container_registry_use_managed_identity" {
  type        = bool
  default     = false
  description = "Should connections for Azure Container Registry use Managed Identity."
}

variable "acr_id" {
  type        = string
  default     = null
  description = "Azure Container Registry ID to create role assignment for ACR_Pull action. Only required to create a RBAC role for the App Service when using an Azure Container Registry as the image source."
}

variable "create_acr_role_assignment" {
  type        = bool
  default     = false
  description = "Should a role assignment be created so that the App Service can pull the image from the Azure Container Registry."
}

variable "app_service_always_on" {
  type        = bool
  default     = true
  description = "If this Linux Web App is Always On enabled."
}

variable "docker_registry_url" {
  type        = string
  description = "The URL of the container registry where the docker_image_name is located. e.g. https://index.docker.io or https://mcr.microsoft.com ."
}

variable "docker_image_name" {
  type        = string
  description = "The docker image name to be used."
}

variable "docker_image_tag" {
  type        = string
  description = "The docker image tag to be used."
}

variable "container_port" {
  type        = number
  description = "The port number to which requests will be sent, corresponds to the port exposed by the container."
}

variable "https_only" {
  type        = bool
  default     = true
  description = "Should the Linux Web App require HTTPS connections."
}

variable "sku_name" {
  type        = string
  default     = "B1"
  description = "The SKU for the plan. Possible values include B1, B2, B3, D1, F1, I1, I2, I3, I1v2, I2v2, I3v2, I4v2, I5v2, I6v2, P1v2, P2v2, P3v2, P0v3, P1v3, P2v3, P3v3, P1mv3, P2mv3, P3mv3, P4mv3, P5mv3, S1, S2, S3, SHARED, EP1, EP2, EP3, WS1, WS2, WS3, and Y1."
}

variable "custom_sub_domain_name" {
  type        = string
  default     = null
  description = "When creation a custom domain, the sub domain name to create. For example, for creating `myapp.contoso.com`, set the value `myapp`."
}

variable "parent_dns_zone_name" {
  type        = string
  default     = null
  description = "When creating a custom domain, the name of the parent dns zone."
}

variable "parent_dns_zone_resource_group_name" {
  type        = string
  default     = null
  description = "When creating a custom domain, the name of the parent dns zone resource group."
}

variable "cors_allowed_origins" {
  type        = list(string)
  default     = null
  description = "Specifies a list of origins that should be allowed to make cross-origin calls."
}

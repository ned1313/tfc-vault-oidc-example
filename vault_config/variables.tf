variable "vault_server_url" {
  type        = string
  description = "(Required) The URL of the Vault server"
}

variable "vault_namespace" {
  type        = string
  description = "(Optional) The namespace to use for the Vault server. Defaults to null."
  default     = null
}

variable "tfc_organization" {
  type        = string
  description = "(Required) The name of the TFC organization"
}

variable "tfc_workspace" {
  type        = string
  description = "(Required) The name of the TFC workspace"
}

variable "tfc_project" {
  type        = string
  description = "(Required) The name of the TFC project in which the workspace is associated"
  default     = "default"
}

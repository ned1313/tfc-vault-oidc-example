variable "vault_auth_login_jwt_mount" {
  type = string
  description = "(Required) The mount path of the JWT auth method"
}

variable "vault_auth_login_jwt_role" {
  type = string
  description = "(Required) The role name to use for the JWT auth method"
}

variable "vault_secret_path" {
  type = string
  description = "(Required) The path to the secret to read"
}
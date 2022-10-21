provider "vault" {
  # Address from environment variable VAULT_ADDR
  namespace = data.environment_variables.all.items["VAULT_NAMESPACE"]
  auth_login_jwt {
    mount = var.vault_auth_login_jwt_mount
    role  = var.vault_auth_login_jwt_role
    jwt   = data.environment_variables.all.items["TFC_WORKLOAD_IDENTITY_TOKEN"]
  }
}

data "vault_generic_secret" "taco" {
  path = var.vault_secret_path
}

data "environment_variables" "all" {}

resource "local_file" "workspace_token" {
  content  = data.environment_variables.all.items["TFC_WORKLOAD_IDENTITY_TOKEN"]
  filename = "~/tfctoken"
}




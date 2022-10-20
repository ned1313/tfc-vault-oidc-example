provider "vault" {
    # Address from environment variable VAULT_ADDR
    auth_login_jwt {
        mount = var.vault_auth_login_jwt_mount
        role = var.vault_auth_login_jwt_role
        jwt  = data.environment_variables.all.items["TFC_WORKLOAD_IDENTITY_TOKEN"]
    }
}

data "environment_variables" "all" {}

data "vault_generic_secret" "taco" {
  path = var.vault_secret_path
}


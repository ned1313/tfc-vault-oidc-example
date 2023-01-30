provider "vault" {
  address   = var.vault_server_url
  namespace = var.vault_namespace
}

# Create a KV secrets engine
resource "vault_mount" "taco" {
  path        = "tacos-tfc"
  type        = "kv"
  options     = { version = "2" }
  description = "KV mount for TFC OIDC demo"
}

# Create a secret in the KV engine

resource "vault_kv_secret_v2" "taco" {
  mount = vault_mount.taco.path
  name  = "sauce_recipe"
  data_json = jsonencode(
    {
      pepper = "Aji Limon",
      juice  = "Mango"
    }
  )
}

# Create a policy granting the TFC workspace access to the KV engine
resource "vault_policy" "taco" {
  name = "tfc-workspace-oidc"

  policy = <<EOT
# Generate child tokens with Terraform provider
path "auth/token/create" {
capabilities = ["update"]
}

# Used by the token to query itself
path "auth/token/lookup-self" {
capabilities = ["read"]
}

# Get secrets from KV engine
path "${vault_kv_secret_v2.taco.path}" {
  capabilities = ["list","read"]
}
EOT
}

# Create the JWT auth method to use GitHub
resource "vault_jwt_auth_backend" "jwt" {
  description        = "JWT Backend for TFC OIDC"
  path               = "tfc"
  oidc_discovery_url = "https://app.terraform.io"
  bound_issuer       = "https://app.terraform.io"
}

# Create the JWT role tied to the repo
resource "vault_jwt_auth_backend_role" "example" {
  backend           = vault_jwt_auth_backend.jwt.path
  role_name         = "tfc-workspace-oidc"
  token_policies    = [vault_policy.taco.name]
  token_max_ttl     = "100"
  bound_audiences   = ["vault.testing"]
  bound_claims_type = "glob"
  bound_claims = {
    sub = "organization:${var.tfc_organization}:workspace:${var.tfc_workspace}:run_phase:*,organization:${var.tfc_organization}:project:${var.tfc_project}:workspace:${var.tfc_workspace}:run_phase:*"
  }
  user_claim = "terraform_full_workspace"
  role_type  = "jwt"
}

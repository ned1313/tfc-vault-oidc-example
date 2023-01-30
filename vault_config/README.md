# Configure the Vault Server

This directory contains Terraform code for configuring a Vault server to support OIDC authentication from Terraform Cloud workload identity JWT.

## Prerequisites

You'll need the following to complete the configuration:

* A HashiCorp Vault instance with a public interface (I used HCP Vault)
* A token for the Vault server, or you can update the provider configuration to use an alternate authentication method

## What the Code Does

The code in this directory will do the following:

* Create a Vault policy for the TFC workspace with permissions to manage child tokens and read a secret
* Create a JWT auth method called `tfc` pointing to the TFC URL (This would need to be updated if you're using TFE)
* Create a role called `tfc-workspace-oidc` using the JWT method and the policy created earlier
* Enable a KVv2 secrets engine at the path `tacos-tfc` with the secret `sauce_recipe`

## Deploying the Configuration

These are Terraform and environment variable values that you should set:

* `VAULT_TOKEN` - Environment variable with the token to be used with the Vault Server with permissions to create an authentication method, create an access policy, mount a k/v secrets engine, and write a secret to that engine
* `vault_server_url` = Terraform variable to set the Vault server URL
* `vault_namespace` = Terraform variable to set the Vault namespace (if using Vault Enterprise or HCP Vault)
* `tfc_workspace` = The TFC workspace that will access the secret
* `tfc_organization` = The TFC organization containing the workspace
* `tfc_project` = The TFC project in which the workspace is associated - default is "default"

Once you have those values set, you can deploy the configuration with the following commands:

```bash
terraform init
terraform apply -auto-approve
```

The next step is to configure your TFC workspace. Use the directions found in the parent directory.

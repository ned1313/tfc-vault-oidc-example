# tfc-vault-oidc-example

Example of using workload identity in Terraform Cloud with Vault

## Introduction

This directory contains Terraform code for testing the Vault OIDC authentication flow by authenticating and grabbing a secret value created by the `vault_config` code.

## Prerequisites

You should already have the following configured:

* A HashiCorp Vault instance configured with OIDC authentication
* A Terraform Cloud organization and workspace you'll use to test the authentication flow

## Before You Run the Code

You're going to need to configure your workspace in TFC before you can run the code.

You'll need to set the following environment variables:

* `TF_LOG` - Set to `TRACE` to see the full logs from the Vault provider
* `TFC_WORKLOAD_IDENTITY_AUDIENCE` - The audience to use for the workload identity (default: `vault.testing`)
* `VAULT_ADDR` - The URL of the Vault server including the port number
* `VAULT_NAMESPACE` - The Vault namespace to use (if using Vault Enterprise or HCP Vault)
  * HCP Vault has a default namespace of `admin`

You'll also need to set the following Terraform variables:

* `vault_secret_path` - The path to the secret in Vault (default: `tacos-tfc/sauce_recipe`)
* `vault_auth_login_jwt_role` - The name of the role to use for the JWT auth method (default: `tfc-workspace-oidc`)
* `vault_auth_login_jwt_mount` - The name of the JWT auth method to use (default: `tfc`)

## What the Code Does

The code in this directory will attempt to authenticate to Vault and grab the secret created earlier as a data source. It will then output the value of the secret. The code leverages the `environment` provider to access the JWT stored in the environment variable `TFC_WORKLOAD_IDENTITY_TOKEN`. That's a bit of a kludge for the moment, and I expect HashiCorp to provide a better way to access the JWT in the future.

## Deploying the Configuration

You can either run this using VCS or from your CLI.

If you choose to use the CLI, you'll need to add the `cloud` block to the `terraform.tf` file. Then simply run `terraform init` and `terraform apply` to run the code.

If you are using the VCS workflow, simply link your workspace to a forked instance of this repository and run a plan.

## Next Steps

That's it! You've now configured a Vault server to support OIDC authentication from a TFC workspace using workload identities! Go forth and celebrate!

## Troubleshooting

If the configuration fails, I recommend commenting out the Vault provider block and output block, and uncommenting the local file block. This will write the JWT to a file in the current directory and show you the contents of the JWT. You can then use the [JWT Debugger](https://jwt.io/) to see what's in the JWT and troubleshoot the issue. Chances are the properties of the JWT auth method or role are not configured correctly. Check the audience, issuer, and subject from the JWT against the configuration of the JWT auth method and role.

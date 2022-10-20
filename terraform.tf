terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }

    environment = {
      source  = "EppO/environment"
      version = "~>1.0"
    }
  }

}
/*
output "secret_data" {
  value = nonsensitive(data.vault_generic_secret.taco.data)
}*/

output "token_info" {
  value = data.environment_variables.all.items
}
output "yaml_contents" {
  value = local.yaml_contents
}

output "active_key_name" {
  value = values(module.azuread_credentials)[*].active_key_name
}
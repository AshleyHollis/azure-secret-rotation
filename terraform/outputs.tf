output "yaml_contents" {
  value = local.yaml_contents
}

output "all_active_key_names" {
  value = values(module.azuread_credentials)[*].active_key_name
}
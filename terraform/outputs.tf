output "yaml_contents" {
  value = local.yaml_contents
}

output "active_key_name" {
  value = { for k, v in module.azuread_credentials : k => v.active_key_name }
}
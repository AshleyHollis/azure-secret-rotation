output "yaml_contents" {
  value = local.yaml_contents
}

# output "active_key" {
#   value = { for k, v in module.azuread_credentials : k => v.active_key }
# }

output "rotation_info" {
  value = { for k, v in module.azuread_credentials : k => v.rotation_info }  
  description = "Information about the last password rotation."
}
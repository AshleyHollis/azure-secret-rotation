# module "dynamic_keyvault_secrets" {
#   source = "./modules/dynamic_keyvault_secrets"
#   for_each = local.secrets

#   name        = each.value.name
#   key_vault_id = var.central_key_vault_id
#   config      = try(each.value.config, null)
# }

data "azuread_application" "main" {
  for_each = local.azuread_credentials
  
  display_name = each.key
}

module "azuread_credentials" {
  source     = "./modules/azuread_credentials"
  providers = {
    counters = counters
  }

  for_each   = local.azuread_credentials

  central_key_vault_id = var.central_key_vault_id
  key_vault_ids = [ var.central_key_vault_id ]
  application = {
    name = each.key
    object_id = data.azuread_application.main[each.key].object_id
  }
  # previous_active_key = try(data.terraform_remote_state.current_state.outputs.active_key[each.key], "")
  rotation_info = try(data.terraform_remote_state.current_state.outputs.rotation_info[each.key], null)
}
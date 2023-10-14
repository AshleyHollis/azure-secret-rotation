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
  for_each   = local.azuread_credentials

  key_vault_ids = [ var.central_key_vault_id ]
  application = {
    name = each.key
    object_id = data.azuread_application.main[each.key].object_id
  }
  # application_object_id = data.azuread_application.main[each.key].object_id
}
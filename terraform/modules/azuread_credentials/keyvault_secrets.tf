
# resource "azurerm_key_vault_secret" "client_id" {
#   for_each = try(var.settings.keyvaults, {})

#   name         = format("%s-client-id", each.value.secret_prefix)
#   key_vault_id = try(each.value.lz_key, null) == null ? var.keyvaults[var.client_config.landingzone_key][each.key].id : var.keyvaults[each.value.lz_key][each.key].id

#   value = coalesce(
#     try(var.resources.application.application_id, null)
#   )
# }

# resource "azurerm_key_vault_secret" "tenant_id" {
#   for_each     = try(var.settings.keyvaults, {})
#   name         = format("%s-tenant-id", each.value.secret_prefix)
#   value        = try(each.value.tenant_id, var.client_config.tenant_id)
#   key_vault_id = try(each.value.lz_key, null) == null ? var.keyvaults[var.client_config.landingzone_key][each.key].id : var.keyvaults[each.value.lz_key][each.key].id
# }

# to support keyvault in a different subscription
# resource "azapi_resource" "sqlmi_admin_password" {
#   count = try(var.settings.administratorLoginPassword, null) == null ? 1 : 0

#   type      = "Microsoft.KeyVault/vaults/secrets@2021-11-01-preview"
#   name      = format("%s-password-v1", azurecaf_name.mssqlmi.result)
#   parent_id = var.keyvault.id

#   body = jsonencode({
#     properties = {
#       attributes = {
#         enabled = true
#       }
#       value = random_password.sqlmi_admin.0.result
#     }
#   })

#   ignore_missing_property = true
# }

resource "azurerm_key_vault_secret" "client_secret" {
  for_each = toset(var.key_vault_ids)

  # Add a timer to make sure the new password got replicated into azure ad replica set before we store it into keyvault
  depends_on = [time_sleep.wait_new_password_propagation]

  # name            = format("%s-client-secret", each.value.secret_prefix)
  name            = format("%s-client-secret", var.application.name)
  value           = sensitive(local.active_key_value)
  key_vault_id    = each.value
  expiration_date = local.active_key_value.end_date

  tags = {
    key = local.most_recent_key_name
    description = local.description[local.most_recent_key_name]
  }
}
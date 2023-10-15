# data "azapi_resource_id" "central_key_vault" {
#   type      = "Microsoft.KeyVault/vaults@2023-02-01"
#   name      = var.central_key_vault_name
# }

# data "azurerm_key_vault" "key_vault" {
#   for_each = { for kv in flatten([for secret in data.external.parse_secrets.result.secrets : secret.keyVaults]) : kv.name => kv }

#   provider = azurerm[each.value.subscription_name]
#   name     = each.value.name
#   resource_group_name = each.value.resource_group
# }

data "terraform_remote_state" "current_state" {
  backend = "remote"
  config = {
    organization = "AshleyHollis"
    workspaces = {
      name = "azure-secret-rotation-secrets"
    }
  }
}
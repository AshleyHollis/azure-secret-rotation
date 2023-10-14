resource "random_password" "value" {
  length           = try(var.config.length, 16)
  special          = try(var.config.special, true)
  override_special = try(var.config.override_special, "_!@")
}

resource "azurerm_key_vault_secret" "secret" {
  name         = var.name
  value        = random_password.value.result
  key_vault_id = var.key_vault_id

  lifecycle {
    ignore_changes = [
      key_vault_id
    ]
  }
}
locals {
  default_rotation_policy = {
    # Define the number of days the password is valid. It must be more than the rotation frequency
    expire_in_days = 380
    rotation = {
      # Set how often the password must be rotated. When passed the renewal time, running the terraform plan / apply will change to a new password
      # Only set one of the value
      # Note - once set cannot switch between mins/days/months. Only the value can be adjusted.

      mins = 1 # only recommended for CI and demo
      # days = 180
      # months = 1
    }
  }

  rotation_policy = var.rotation_policy == null ? local.default_rotation_policy : var.rotation_policy

  expiration_dates = {
    # key0 = timeadd(time_rotating.main.id, format("%sh", local.rotation_policy.expire_in_days * 24))
    # key1 = timeadd(time_rotating.main.id, format("%sh", local.rotation_policy.expire_in_days * 24))
    key0 = azuread_application_password.key0.end_date
    key1 = azuread_application_password.key1.end_date    
  }

  description = {
    key0 = try(format(
      "key0-%s-%s",
      formatdate("YYMMDDhhmmss", time_rotating.main.rotation_rfc3339),
      formatdate("YYMMDDhhmmss", local.expiration_dates.key0)
    ), null)
    key1 = try(format(
      "key1-%s-%s",
      formatdate("YYMMDDhhmmss", time_rotating.main.rotation_rfc3339),
      formatdate("YYMMDDhhmmss", local.expiration_dates.key1)
    ), null)
  }

  most_recent_key_name = sort([local.expiration_dates.key0, local.expiration_dates.key1])[1] == local.expiration_dates.key0 ? "key0" : "key1"
  rotate_key0 = local.most_recent_key_name == "key1" ? time_rotating.main.id : null
  rotate_key1 = local.most_recent_key_name == "key0" ? time_rotating.main.id : null

  # Everytime the code run it re-evalute the key to store in the keyvault secret
  active_key_value = local.most_recent_key_name == "key0" ? azuread_application_password.key0.value : azuread_application_password.key1.value
}

resource "time_rotating" "main" {
  rotation_minutes = try(local.rotation_policy.rotation.mins, null)
  rotation_days    = try(local.rotation_policy.rotation.days, null)
  rotation_months  = try(local.rotation_policy.rotation.months, null)
  rotation_years   = try(local.rotation_policy.rotation.years, null)  
}

resource "null_resource" "rotation_trigger" {
  triggers = {
    rotation_time = time_rotating.main.id
  }
}

data "azurerm_key_vault_secret" "rotation_incrementer" {
  name         = "rotation-incrementer"
  key_vault_id = var.central_key_vault_id
}

resource "azurerm_key_vault_secret" "rotation_incrementer" {
  name         = "rotation-incrementer"
  value        = tostring(local.new_incrementer)
  key_vault_id = var.central_key_vault_id
}

locals {
  current_incrementer = try(tonumber(data.azurerm_key_vault_secret.rotation_incrementer.value), 0)
  new_incrementer = local.current_incrementer + 1
  is_even_incrementer = local.current_incrementer % 2 == 0
}
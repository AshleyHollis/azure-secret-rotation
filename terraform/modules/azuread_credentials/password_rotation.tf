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

  new_expiry_date = timeadd(time_rotating.main.id, format("%sh", local.rotation_policy.expire_in_days * 24))

  expiration_dates = {
    key0 = var.previous_active_key.name == "key1" ? local.new_expiry_date : var.previous_active_key.end_date
    key1 = var.previous_active_key.name == "key0" ? local.new_expiry_date : var.previous_active_key.end_date
  }

  description = {
    key0 = ""
    # key0 = try(format(
    #   "key0-%s-%s",
    #   formatdate("YYMMDDhhmmss", time_rotating.key0.0.rotation_rfc3339),
    #   formatdate("YYMMDDhhmmss", local.expiration_dates.key0)
    # ), null)
    key1 = ""
    # key1 = try(format(
    #   "key1-%s-%s",
    #   formatdate("YYMMDDhhmmss", time_rotating.key1.0.rotation_rfc3339),
    #   formatdate("YYMMDDhhmmss", local.expiration_dates.key1)
    # ), null)
  }

  # most_recent_key_name = sort([azuread_application_password.key0.end_date, azuread_application_password.key1.end_date])[1] == azuread_application_password.key0.end_date ? "key0" : "key1"
  #  most_recent_key_name = sort([try(local.expiration_dates.key0, 1), try(local.expiration_dates.key1, 1)])[1] == try(local.expiration_dates.key0, 1) ? "key0" : "key1"
  most_recent_key_name = sort([local.expiration_dates.key0, local.expiration_dates.key1])[1] == local.expiration_dates.key0 ? "key0" : "key1"
  # rotate_key0 = local.most_recent_key_name == "key1" ? time_rotating.key0.0.id : null
  # rotate_key1 = local.most_recent_key_name == "key0" ? time_rotating.key1.0.id : null

  # Everytime the code run it re-evalute the key to store in the keyvault secret
  active_key_value = local.most_recent_key_name == "key0" ? azuread_application_password.key0.value : azuread_application_password.key1.value
}

resource "time_rotating" "main" {
  rotation_minutes = try(local.rotation_policy.rotation.mins, null)
  rotation_days    = try(local.rotation_policy.rotation.days, null)
  rotation_months  = try(local.rotation_policy.rotation.months, null)
  rotation_years   = try(local.rotation_policy.rotation.years, null)
}

# resource "time_rotating" "key1" {
#   rotation_minutes = try(local.rotation_policy.rotation.mins, null)
#   rotation_days    = try(local.rotation_policy.rotation.days, null)
#   rotation_months  = try(local.rotation_policy.rotation.months, null)
#   rotation_years   = try(local.rotation_policy.rotation.years, null)
# }
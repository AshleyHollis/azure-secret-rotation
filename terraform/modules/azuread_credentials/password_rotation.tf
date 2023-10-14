#
# key is used when
#
# Keys generated when using the password policy
#  Key0 password_policy.rotation.days is an odd number
#  Key1 password_policy.rotation.days is an even number
#

locals {
  password_policy = try(var.azuread_credential_policy_key, null) == null ? var.policy : var.credential_policy

  expiration_date = {
    key  = try(var.azuread_credential_policy_key, null) == null ? timeadd(time_rotating.key.0.id, format("%sh", local.password_policy.expire_in_days * 24)) : null
    key0 = try(var.azuread_credential_policy_key, null) != null ? timeadd(time_rotating.key0.0.id, format("%sh", local.password_policy.expire_in_days * 24)) : null
    key1 = try(var.azuread_credential_policy_key, null) != null ? timeadd(time_rotating.key1.0.id, format("%sh", local.password_policy.expire_in_days * 24)) : null
  }

  description = {
    key = try(format(
      "key-%s-%s",
      formatdate("YYMMDDhhmmss", time_rotating.key.0.rotation_rfc3339), // Next rotation date
      formatdate("YYMMDDhhmmss", local.expiration_date.key)             // Credential expiration date
    ), null)
    key0 = try(format(
      "key0-%s-%s",
      formatdate("YYMMDDhhmmss", time_rotating.key0.0.rotation_rfc3339),
      formatdate("YYMMDDhhmmss", local.expiration_date.key0)
    ), null)
    key1 = try(format(
      "key1-%s-%s",
      formatdate("YYMMDDhhmmss", time_rotating.key1.0.rotation_rfc3339),
      formatdate("YYMMDDhhmmss", local.expiration_date.key1)
    ), null)
  }

  key = {
    # Coming from the default variables.tf id an azuread_credential_policies was not set
    mins   = try(local.password_policy.rotation_key0.mins, null)
    days   = try(local.password_policy.rotation_key0.days, null)
    months = try(local.password_policy.rotation_key0.months, null)
    years  = try(local.password_policy.rotation_key0.years, null)
  }

  key0 = {
    mins   = try(local.password_policy.rotation_key0.mins, null)
    days   = try(local.password_policy.rotation_key0.days, null)
    months = try(local.password_policy.rotation_key0.months, null)
    years  = try(local.password_policy.rotation_key0.years, null)
  }

  key1 = {
    mins   = try(local.password_policy.rotation_key1.mins, null)
    days   = try(local.password_policy.rotation_key1.days, null)
    months = try(local.password_policy.rotation_key1.months, null)
    years  = try(local.password_policy.rotation_key1.years, null)    
  }
}

resource "time_rotating" "key" {
  count         = try(var.azuread_credential_policy_key, null) == null ? 1 : 0

  rotation_minutes = try(local.key.mins, null)
  rotation_days    = try(local.key.days, null)
  rotation_months  = try(local.key.months, null)
  rotation_years   = try(local.key.years, null)
}

resource "time_rotating" "key0" {
  count         = try(var.azuread_credential_policy_key, null) != null ? 1 : 0

  rotation_minutes = try(local.key0.mins, null)
  rotation_days    = try(local.key0.days, null)
  rotation_months  = try(local.key0.months, null)
  rotation_years   = try(local.key0.years, null)  
}

resource "time_rotating" "key1" {
  count         = try(var.azuread_credential_policy_key, null) != null ? 1 : 0

  rotation_minutes = try(local.key1.mins, null)
  rotation_days    = try(local.key1.days, null)
  rotation_months  = try(local.key1.months, null)
  rotation_years   = try(local.key1.years, null)  
}
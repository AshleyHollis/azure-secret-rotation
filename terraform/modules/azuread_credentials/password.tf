resource "azuread_application_password" "key0" {
  display_name = try(var.display_name, local.description.key0)
  end_date = local.expiration_dates.key0

  application_object_id = var.application.object_id

  rotate_when_changed = {
    rotation = time_rotating.key0.id
  }

  lifecycle {
    #create_before_destroy = true
  }
}

resource "azuread_application_password" "key1" {
  display_name = try(var.display_name, local.description.key1)
  end_date     = local.expiration_dates.key1

  application_object_id = var.application.object_id

  rotate_when_changed = {
    rotation = time_rotating.key1.id
  }

  lifecycle {
    #create_before_destroy = true
  }
}

resource "time_sleep" "wait_new_password_propagation" {
  depends_on = [azuread_application_password.key0, azuread_application_password.key1]

  # 2 mins timer on creation
  create_duration = "2m"

  # 15 mins to allow new password to be propagated in directory partitions when password changes
  # destroy_duration = "15m"

  triggers = {
    key0 = try(time_rotating.key0.rotation_rfc3339, null)
    key1 = try(time_rotating.key1.rotation_rfc3339, null)
  }
}
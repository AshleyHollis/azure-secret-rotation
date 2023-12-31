resource "azuread_application_password" "key0" {
  display_name = try(var.display_name, local.description.key0)
  # end_date = local.expiration_dates.key0
  # end_date_relative     = "8760h" # 1 year
  end_date_relative     = local.password_expiry_duration

  application_object_id = var.application.object_id

  # rotate_when_changed = {
  #   # Trigger only when other key is active and use new expiry date for initial deployment.
  #   trigger = try(var.previous_active_key.name, null) == "key1" && local.rotation_required ? time_rotating.main.id : try(var.previous_active_key.last_rotation_trigger_date, time_rotating.main.id)
  # }

  rotate_when_changed = {
    should_rotate = local.rotate_key0 ? "true" : "false"
  }

  lifecycle {
    #create_before_destroy = true
  }
}

resource "azuread_application_password" "key1" {
  display_name = try(var.display_name, local.description.key1)
  # end_date     = local.expiration_dates.key1
  # end_date_relative     = "8760h" # 1 year
  end_date_relative     = local.password_expiry_duration

  application_object_id = var.application.object_id

  # rotate_when_changed = {
  #   # Trigger only when other key is active and use new expiry date for initial deployment.
  #   trigger = try(var.previous_active_key.name, null) == "key0" && local.rotation_required ? time_rotating.main.id : try(var.previous_active_key.last_rotation_trigger_date, time_rotating.main.id)
  # }

  rotate_when_changed = {
    should_rotate = local.rotate_key1 ? "true" : "false"
  }

  lifecycle {
    #create_before_destroy = true
  }
}

# resource "time_sleep" "wait_new_password_propagation" {
#   depends_on = [azuread_application_password.key0, azuread_application_password.key1]

#   # 2 mins timer on creation
#   create_duration = "2m"

#   # 15 mins to allow new password to be propagated in directory partitions when password changes
#   # destroy_duration = "15m"

#   triggers = {
#     key0 = try(time_rotating.main.rotation_rfc3339, null)
#     key1 = try(time_rotating.main.rotation_rfc3339, null)
#   }
# }
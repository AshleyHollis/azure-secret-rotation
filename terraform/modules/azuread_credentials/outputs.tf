# output "active_key" {
#   value = {
#     name = local.most_recent_key_name
#     end_date = local.new_expiry_date
#     last_rotation_trigger_date = time_rotating.main.id
#   }
# }

output "rotation_info" {
  value = {
    active_key_name = local.rotate_key0 ? "key1" : "key0",
    last_rotation   = local.current_time
  }
  description = "Information about the last password rotation."
}
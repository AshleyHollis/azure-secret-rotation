output "active_key" {
  value = {
    name = local.most_recent_key_name
    end_date = local.new_expiry_date
    last_rotation_trigger_date = time_rotating.main.id
  }
}
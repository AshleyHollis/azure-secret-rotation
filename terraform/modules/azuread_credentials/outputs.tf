output "active_key" {
  value = {
    name = local.most_recent_key_name
    end_date = local.new_expiry_date
  }
}
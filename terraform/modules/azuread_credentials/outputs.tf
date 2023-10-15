output "active_key_name" {
  value = {
    name = local.most_recent_key_name
    end_date = local.active_key_value.end_date
  } 
}
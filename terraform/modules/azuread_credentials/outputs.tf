output "active_key" {
  value = {
    name = local.most_recent_key_name
    end_date = try(local.active_key_value.end_date, null)
  } 
}
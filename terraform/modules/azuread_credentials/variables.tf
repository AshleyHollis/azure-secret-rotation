variable "application" {
  type = object({
    name = string
    object_id = string
  })
}

variable "display_name" {
  default = null
}

variable "key_vault_ids" {
  default = []
}

variable "rotation_policy" {
  description = "Custom rotation policy to apply."
  default     = null
}

variable "central_key_vault_id" {
  type = string
}

variable "previous_active_key" {}

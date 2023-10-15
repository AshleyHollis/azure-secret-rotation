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

# variable "previous_active_key" {}

variable "rotation_frequency_hours" {
  description = "Frequency (in hours) at which the passwords should be rotated."
  type        = number
  default     = 24
}

variable "password_expiry_buffer_hours" {
  description = "Buffer time (in hours) after the rotation frequency before the password expires."
  type        = number
  default     = 24
}

variable "rotation_info" {

}
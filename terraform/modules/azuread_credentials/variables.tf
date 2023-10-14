variable "application" {
  type = object({
    name = string
    object_id = string
  })
}

variable "azuread_credential_policy_key" {
  default = null
}

variable "display_name" {
  default = null
}

variable "key_vault_ids" {
  default = []
}

variable "credential_policy" {
  description = "Custom credential policy to apply."
  default     = null
}

variable "policy" {
  description = "Default credential policy to apply."
  default = {
    # Length of the password
    length  = 250
    special = false
    upper   = true
    number  = true

    # Define the number of days the password is valid. It must be more than the rotation frequency
    expire_in_days = 380
    rotation_key0 = {
      # Odd number
      #
      # Set how often the password must be rotated. When passed the renewal time, running the terraform plan / apply will change to a new password
      # Only set one of the value
      # Note - once set cannot switch between mins/days/months. Only the value can be adjusted.
      #

      mins = 10 # only recommended for CI and demo
      # days = 180
      # months = 1
    }
    rotation_key1 = {
      # Even number
      #
      # Set how often the password must be rotated. When passed the renewal time, running the terraform plan / apply will change to a new password
      # Only set one of the value
      # Note - once set cannot switch between mins/days/months. Only the value can be adjusted.
      #

      mins = 10 # only recommended for CI and demo
      # days = 361
      # months = 1
    }
  }
}
variable "base_dir" {
  description = "The base directory to search for YAML files"
  type        = string
  default     = "./config/non-prod"
}

variable "subscription_lookup" {
  description = "Map of subscription names to subscription IDs"
  type = map(string)
  default = {
    "CentralSubscription"     = "xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx",
    "LandingZone1Subscription" = "yyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyy"
    # ... add more as necessary
  }
}

variable "central_keyvaults" {
  description = "Central Key Vaults for each environment"
  type = map(object({
    subscription_name = string
    resource_group    = string
    name              = string
  }))
  default = {
    "nonprod" = {
      subscription_name = "NonProdSubscriptionName",
      resource_group    = "NonProdResourceGroup",
      name              = "nonprodCentralKeyVault"
    },
    "prod" = {
      subscription_name = "ProdSubscriptionName",
      resource_group    = "ProdResourceGroup",
      name              = "prodCentralKeyVault"
    }
    # ... add more environments as necessary
  }
}

variable "central_key_vault_id" {
  type = string
}

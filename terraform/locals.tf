locals {
  yaml_contents = yamldecode(file("${path.module}/config/non-prod/proj_a/app_a.yaml"))
  secrets = { for key, secret in local.yaml_contents.secrets : secret.name => secret }

  azuread_credentials = {for key, secret in local.secrets : secret.name => secret if secret.resource.type == "AppRegistrationPassword"}
}
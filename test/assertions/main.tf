locals {
  owner = "myself"
}

module "mysql" {
  source = "../../"

  owner       = local.owner
  project     = local.project
  environment = local.environment

  purpose                    = "test-mysql with a name that's way too long and have invalid chars!"
  admin_user_crypto_key      = var.admin_user_crypto_key
  admin_user_password_cipher = var.admin_user_password_cipher
}

output "mysql" {
  value = module.mysql
}

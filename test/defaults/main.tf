locals {
  owner = "myself"
}

module "mysql" {
  source = "../../"

  owner       = local.owner
  project     = local.project
  environment = local.environment

  purpose                    = "test-mysql"
  admin_user_crypto_key      = var.admin_user_crypto_key
  admin_user_password_cipher = var.admin_user_password_cipher

  ip_configuration = {
    ipv4_enabled    = false
    require_ssl     = true
    private_network = var.network
  }
}

output "mysql" {
  value = module.mysql
}


locals {
  owner       = "myself"
  project     = "demo"
  environment = "dev"
}

module "mysql" {
  source  = "binxio/cloudsql/google"
  version = "~> 1.0.0"

  owner       = local.owner
  project     = local.project
  environment = local.environment

  purpose                    = "demo-mysql"
  admin_user_crypto_key      = var.admin_user_crypto_key
  admin_user_password_cipher = var.admin_user_password_cipher

  ip_configuration = {
    ipv4_enabled    = false
    require_ssl     = true
    private_network = var.network
  }
}

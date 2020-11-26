locals {
  owner = "myself"
}

module "mysql" {
  source = "../../"

  owner       = local.owner
  project     = local.project
  environment = local.environment

  region           = "europe-west4"
  database_version = "MYSQL_5_7"
  purpose          = "test-mysql"

  admin_user_crypto_key      = var.admin_user_crypto_key
  admin_user_password_cipher = var.admin_user_password_cipher

  database_flags = [
    {
      name  = "log_bin_trust_function_creators"
      value = "on"
    }
  ]

  failover_replica_database_flags = [{
    name  = "log_bin_trust_function_creators"
    value = "on"
  }]

  ip_configuration = {
    ipv4_enabled    = false
    require_ssl     = true
    private_network = var.network
    authorized_networks = [
      {
        name  = "test"
        value = "0.0.0.0/0"
      },
      {
        name  = "example2"
        value = "0.0.0.0/0"
      }
    ]
  }

  failover_replica_ip_configuration = {
    ipv4_enabled    = false
    require_ssl     = true
    private_network = var.network
  }

  read_replica_ip_configuration = {
    ipv4_enabled    = false
    require_ssl     = true
    private_network = var.network
  }

  tier                  = "db-f1-micro"
  read_replica_tier     = "db-f1-micro"
  failover_replica_tier = "db-f1-micro"
  disk_size             = 10
  read_replica_size     = 1
  //  additional_databases  = ["db_main", "db_main_bananas"]
}

output "mysql" {
  value = module.mysql
}


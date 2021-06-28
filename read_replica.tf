resource "google_sql_database_instance" "read" {
  count = var.read_replica_size

  name                 = format("%s-%s", local.master_instance_name, count.index)
  database_version     = local.database_version
  region               = local.region
  master_instance_name = local.master_instance_name

  replica_configuration {
    ca_certificate            = local.read_replica.replica_configuration.ca_certificate
    client_certificate        = local.read_replica.replica_configuration.client_certificate
    client_key                = local.read_replica.replica_configuration.client_key
    connect_retry_interval    = local.read_replica.replica_configuration.connect_retry_interval
    dump_file_path            = local.read_replica.replica_configuration.dump_file_path
    master_heartbeat_period   = local.read_replica.replica_configuration.master_heartbeat_period
    password                  = local.read_replica.replica_configuration.password
    ssl_cipher                = local.read_replica.replica_configuration.ssl_cipher
    username                  = local.read_replica.replica_configuration.username
    verify_server_certificate = local.read_replica.replica_configuration.verify_server_certificate
  }

  settings {
    disk_autoresize   = true
    disk_size         = local.read_replica.settings.disk_size
    pricing_plan      = local.read_replica.settings.pricing_plan
    tier              = local.read_replica.settings.tier
    activation_policy = local.read_replica.settings.activation_policy
    availability_type = local.read_replica.settings.availability_type
    user_labels       = merge({ instance_type = "read_replica" }, local.labels)

    ip_configuration {
      ipv4_enabled    = local.read_replica.settings.ip_configuration.ipv4_enabled
      require_ssl     = local.read_replica.settings.ip_configuration.require_ssl
      private_network = local.read_replica.settings.ip_configuration.private_network

      dynamic "authorized_networks" {
        for_each = local.read_replica.settings.ip_configuration.authorized_networks
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.value
        }
      }
    }

    dynamic "database_flags" {
      for_each = local.read_replica.settings.database_flags
      content {
        name  = database_flags.value.name
        value = database_flags.value.value
      }
    }
  }

  depends_on = [google_sql_database_instance.master]

  lifecycle {
    ignore_changes = [
      settings[0].disk_size,
      settings[0].ip_configuration["ipv4_enabled"],
      settings[0].ip_configuration[0].ipv4_enabled,
    ]
  }
}

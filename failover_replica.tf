resource "google_sql_database_instance" "failover" {
  for_each = (var.failover_replica ? { failover_replica = local.failover_replica.instance_name } : {})

  name                 = local.failover_replica.instance_name
  database_version     = local.database_version
  region               = local.region
  master_instance_name = local.master_instance_name

  replica_configuration {
    failover_target           = true
    ca_certificate            = local.failover_replica.replica_configuration.ca_certificate
    client_certificate        = local.failover_replica.replica_configuration.client_certificate
    client_key                = local.failover_replica.replica_configuration.client_key
    connect_retry_interval    = local.failover_replica.replica_configuration.connect_retry_interval
    dump_file_path            = local.failover_replica.replica_configuration.dump_file_path
    master_heartbeat_period   = local.failover_replica.replica_configuration.master_heartbeat_period
    password                  = local.failover_replica.replica_configuration.password
    ssl_cipher                = local.failover_replica.replica_configuration.ssl_cipher
    username                  = local.failover_replica.replica_configuration.username
    verify_server_certificate = local.failover_replica.replica_configuration.verify_server_certificate
  }

  settings {
    disk_autoresize   = true
    disk_size         = local.failover_replica.settings.disk_size
    pricing_plan      = local.failover_replica.settings.pricing_plan
    tier              = local.failover_replica.settings.tier
    activation_policy = local.failover_replica.settings.activation_policy
    availability_type = local.failover_replica.settings.availability_type
    user_labels       = merge({ instance_type = "failover_replica" }, local.labels)

    maintenance_window {
      day          = local.failover_replica.settings.maintenance_window.day
      hour         = local.failover_replica.settings.maintenance_window.hour
      update_track = local.failover_replica.settings.maintenance_window.update_track
    }

    ip_configuration {
      ipv4_enabled    = local.failover_replica.settings.ip_configuration.ipv4_enabled
      require_ssl     = local.failover_replica.settings.ip_configuration.require_ssl
      private_network = local.failover_replica.settings.ip_configuration.private_network

      dynamic "authorized_networks" {
        for_each = local.failover_replica.settings.ip_configuration.authorized_networks
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.value
        }
      }
    }

    dynamic "database_flags" {
      for_each = local.failover_replica.settings.database_flags
      content {
        name  = database_flags.value.name
        value = database_flags.value.value
      }
    }
  }

  depends_on = [google_sql_database_instance.master]

  lifecycle {
    ignore_changes = [
      settings[0].disk_size
    ]
  }
}

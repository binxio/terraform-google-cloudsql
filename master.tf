resource "google_sql_database_instance" "master" {
  name = local.instance_name

  database_version    = local.database_version
  region              = local.region
  deletion_protection = local.deletion_protection

  settings {
    disk_autoresize   = true
    disk_size         = local.settings.disk_size
    pricing_plan      = local.settings.pricing_plan
    tier              = local.settings.tier
    activation_policy = local.settings.activation_policy
    availability_type = local.settings.availability_type
    user_labels       = merge({ instance_type = "master" }, local.labels)

    backup_configuration {
      binary_log_enabled             = local.settings.backup_configuration.binary_log_enabled
      enabled                        = local.settings.backup_configuration.enabled
      start_time                     = local.settings.backup_configuration.start_time
      point_in_time_recovery_enabled = local.settings.backup_configuration.point_in_time_recovery_enabled
    }

    maintenance_window {
      day          = local.settings.maintenance_window.day
      hour         = local.settings.maintenance_window.hour
      update_track = local.settings.maintenance_window.update_track
    }

    ip_configuration {
      ipv4_enabled    = local.settings.ip_configuration.ipv4_enabled
      require_ssl     = local.settings.ip_configuration.require_ssl
      private_network = local.settings.ip_configuration.private_network

      dynamic "authorized_networks" {
        for_each = local.settings.ip_configuration.authorized_networks
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.value
        }
      }
    }

    dynamic "database_flags" {
      for_each = local.settings.database_flags
      content {
        name  = database_flags.value.name
        value = database_flags.value.value
      }
    }
  }

  lifecycle {
    ignore_changes = [
      public_ip_address,
      settings[0].disk_size,
      settings[0].ip_configuration["ipv4_enabled"],
      settings[0].ip_configuration[0].ipv4_enabled,
      settings[0].version,
    ]
  }
}

resource "google_sql_database" "map" {
  for_each = { for name, settings in var.databases : name => merge(local.defaults[var.engine].database_defaults, settings) }

  name      = each.key
  instance  = google_sql_database_instance.master.name
  charset   = each.value.charset
  collation = each.value.collation
}

data "google_secret_manager_secret_version" "admin_password" {
  for_each = length(var.admin_user_password_secret) > 0 ? toset(["secret"]) : []

  secret  = var.admin_user_password_secret
  version = var.admin_user_password_secret_version
}

data "google_kms_secret" "admin_password" {
  for_each = length(var.admin_user_crypto_key) > 0 ? toset(["kms"]) : []

  crypto_key = var.admin_user_crypto_key
  ciphertext = var.admin_user_password_cipher
}

resource "google_sql_user" "admin_user_kms" {
  for_each = merge(
    { for key, value in data.google_kms_secret.admin_password : (var.admin_user) => value.plaintext },
    { for key, value in data.google_secret_manager_secret_version.admin_password : (var.admin_user) => value.secret_data }
  )

  instance = google_sql_database_instance.master.name
  name     = each.key
  password = each.value
}

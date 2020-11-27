output "settings_defaults" {
  value       = local.module_settings_defaults
  description = "The master settings defaults used"
}
output "replica_settings_defaults" {
  value       = local.module_replica_settings_defaults
  description = "The failover and read replica settings defaults used"
}

// Master
output "instance_name" {
  value       = google_sql_database_instance.master.name
  description = "The instance name for the master instance"
}

output "instance_ip_address" {
  value       = google_sql_database_instance.master.ip_address
  description = "The IPv4 address assigned for the master instance"
}

output "instance_first_ip_address" {
  value       = google_sql_database_instance.master.first_ip_address
  description = "The first IPv4 address of the addresses assigned for the master instance."
}

output "instance_connection_name" {
  value       = google_sql_database_instance.master.connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

output "instance_self_link" {
  value       = google_sql_database_instance.master.self_link
  description = "The URI of the master instance"
}

output "instance_server_ca_cert" {
  value       = google_sql_database_instance.master.server_ca_cert
  description = "The CA certificate information used to connect to the SQL instance via SSL"
}

output "instance_service_account_email_address" {
  value       = google_sql_database_instance.master.service_account_email_address
  description = "The service account email address assigned to the master instance"
}

// Replicas
output "replicas_instance_first_ip_addresses" {
  value       = [google_sql_database_instance.read.*.ip_address]
  description = "The first IPv4 addresses of the addresses assigned for the replica instances"
}

output "replicas_instance_connection_names" {
  value       = [google_sql_database_instance.read.*.connection_name]
  description = "The connection names of the replica instances to be used in connection strings"
}

output "replicas_instance_self_links" {
  value       = [google_sql_database_instance.read.*.self_link]
  description = "The URIs of the replica instances"
}

output "replicas_instance_server_ca_certs" {
  value       = [google_sql_database_instance.read.*.server_ca_cert]
  description = "The CA certificates information used to connect to the replica instances via SSL"
}

output "replicas_instance_service_account_email_addresses" {
  value       = [google_sql_database_instance.read.*.service_account_email_address]
  description = "The service account email addresses assigned to the replica instances"
}

output "read_replica_instance_names" {
  value       = [google_sql_database_instance.read.*.name]
  description = "The instance names for the read replica instances"
}

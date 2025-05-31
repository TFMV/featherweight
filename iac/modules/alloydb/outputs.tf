output "cluster_id" {
  description = "The ID of the AlloyDB cluster"
  value       = google_alloydb_cluster.featherweight.cluster_id
}

output "primary_instance_name" {
  description = "The name of the primary instance"
  value       = google_alloydb_instance.primary.name
}

output "read_pool_instance_name" {
  description = "The name of the read pool instance"
  value       = google_alloydb_instance.read_pool.name
}

output "connection_string" {
  description = "The connection string for the primary instance"
  value       = "postgresql://${var.database_user}:${var.database_password}@${google_alloydb_instance.primary.ip_address}:5432/postgres"
  sensitive   = true
}

output "instance_name" {
  description = "The name of the created instance"
  value       = google_compute_instance.pg_duckdb.name
}

output "instance_ip" {
  description = "The internal IP address of the instance"
  value       = google_compute_instance.pg_duckdb.network_interface[0].network_ip
}

output "public_ip" {
  description = "The public IP address of the instance (if enabled)"
  value       = var.enable_public_ip ? google_compute_instance.pg_duckdb.network_interface[0].access_config[0].nat_ip : null
}

output "connection_string" {
  description = "The PostgreSQL connection string (using internal IP)"
  value       = "postgresql://postgres@${google_compute_instance.pg_duckdb.network_interface[0].network_ip}:5432/postgres"
}

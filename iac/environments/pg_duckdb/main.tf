locals {
  project_id = "tfmv-371720"
  region     = "us-central1"
  zone       = "${local.region}-a"
}

# VPC Network
resource "google_compute_network" "vpc" {
  name                    = "featherweight-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "featherweight-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = local.region
  network       = google_compute_network.vpc.id

  private_ip_google_access = true
}

# Service Account
resource "google_service_account" "pg_duckdb" {
  account_id   = "pg-duckdb-sa"
  display_name = "Service Account for pg_duckdb instance"
}

# Grant necessary roles
resource "google_project_iam_member" "storage_viewer" {
  project = local.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.pg_duckdb.email}"
}

# pg_duckdb instance
module "pg_duckdb" {
  source = "../../modules/gce"

  instance_name         = "pg-duckdb-benchmark"
  machine_type          = "n2-standard-8"
  zone                  = local.zone
  network               = google_compute_network.vpc.id
  subnetwork            = google_compute_subnetwork.subnet.id
  service_account_email = google_service_account.pg_duckdb.email
  enable_public_ip      = false

  allowed_source_ranges = ["10.0.0.0/8"]
}

# Monitoring
module "monitoring" {
  source = "../../modules/monitoring"

  project_id   = local.project_id
  instance_id  = module.pg_duckdb.instance_name
  location     = local.region
  owner_email  = "owner@example.com"  # Change this
  reader_email = "reader@example.com" # Change this
}

# Outputs
output "connection_string" {
  description = "PostgreSQL connection string"
  value       = module.pg_duckdb.connection_string
  sensitive   = true
}

output "instance_ip" {
  description = "Instance internal IP"
  value       = module.pg_duckdb.instance_ip
}

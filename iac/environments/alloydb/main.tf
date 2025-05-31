locals {
  project_id = "featherweight-benchmark" # Change this to your project ID
  region     = "us-central1"
}

# VPC Network
resource "google_compute_network" "vpc" {
  name                    = "featherweight-alloydb-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "featherweight-alloydb-subnet"
  ip_cidr_range = "10.1.0.0/24"
  region        = local.region
  network       = google_compute_network.vpc.id

  private_ip_google_access = true
}

# IP range for AlloyDB
resource "google_compute_global_address" "alloydb_range" {
  name          = "featherweight-alloydb-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = google_compute_network.vpc.id
}

# VPC peering for AlloyDB
resource "google_service_networking_connection" "alloydb_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.alloydb_range.name]
}

# AlloyDB cluster
module "alloydb" {
  source = "../../modules/alloydb"

  cluster_id = "featherweight-benchmark"
  location   = local.region
  network    = google_compute_network.vpc.id
  ip_range   = google_compute_global_address.alloydb_range.name

  database_user     = "postgres"
  database_password = "change-me-in-prod" # Change this in production

  primary_cpu_count      = 8
  read_pool_cpu_count    = 8
  read_pool_node_count   = 2
  columnar_cache_size_mb = 8192 # 8GB
}

# Monitoring
module "monitoring" {
  source = "../../modules/monitoring"

  project_id   = local.project_id
  instance_id  = module.alloydb.primary_instance_name
  location     = local.region
  owner_email  = "owner@example.com"  # Change this
  reader_email = "reader@example.com" # Change this
}

# Outputs
output "connection_string" {
  description = "AlloyDB connection string"
  value       = module.alloydb.connection_string
  sensitive   = true
}

output "primary_instance" {
  description = "Primary instance name"
  value       = module.alloydb.primary_instance_name
}

output "read_pool_instance" {
  description = "Read pool instance name"
  value       = module.alloydb.read_pool_instance_name
}

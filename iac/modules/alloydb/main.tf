resource "google_alloydb_cluster" "featherweight" {
  cluster_id = var.cluster_id
  location   = var.location

  initial_user {
    password = var.database_password
    user     = var.database_user
  }

  network_config {
    network            = var.network
    allocated_ip_range = var.ip_range
  }
}

resource "google_alloydb_instance" "primary" {
  cluster       = google_alloydb_cluster.featherweight.name
  instance_id   = "${var.cluster_id}-primary"
  instance_type = "PRIMARY"

  machine_config {
    cpu_count = var.primary_cpu_count
  }

  database_flags = {
    "max_connections"           = "1000"
    "shared_buffers"            = "8GB"
    "work_mem"                  = "64MB"
    "maintenance_work_mem"      = "2GB"
    "effective_cache_size"      = "24GB"
    "columnar_cache_enabled"    = "true"
    "columnar_cache_memsize_mb" = tostring(var.columnar_cache_size_mb)
  }
}

resource "google_alloydb_instance" "read_pool" {
  cluster       = google_alloydb_cluster.featherweight.name
  instance_id   = "${var.cluster_id}-read-pool"
  instance_type = "READ_POOL"

  read_pool_config {
    node_count = var.read_pool_node_count
  }

  machine_config {
    cpu_count = var.read_pool_cpu_count
  }

  database_flags = {
    "max_connections"           = "1000"
    "shared_buffers"            = "8GB"
    "work_mem"                  = "64MB"
    "maintenance_work_mem"      = "2GB"
    "effective_cache_size"      = "24GB"
    "columnar_cache_enabled"    = "true"
    "columnar_cache_memsize_mb" = tostring(var.columnar_cache_size_mb)
  }
}

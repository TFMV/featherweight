locals {
  startup_script = <<-EOF
    #!/bin/bash
    apt-get update && apt-get install -y postgresql-15 postgresql-server-dev-15 build-essential git cmake libcurl4-openssl-dev

    # Install DuckDB
    git clone https://github.com/duckdb/duckdb.git
    cd duckdb && make -j$(nproc) && make install

    # Install pg_duckdb
    git clone https://github.com/alitrack/pg_duckdb.git
    cd pg_duckdb && make && make install

    # Configure PostgreSQL
    cat > /etc/postgresql/15/main/conf.d/pg_duckdb.conf <<EOL
    shared_preload_libraries = 'pg_duckdb'
    max_connections = 100
    shared_buffers = 4GB
    work_mem = 64MB
    maintenance_work_mem = 1GB
    effective_cache_size = 12GB
    EOL

    # Initialize and start PostgreSQL
    systemctl enable postgresql
    systemctl start postgresql

    # Create database and enable extension
    su - postgres -c "psql -c 'CREATE EXTENSION pg_duckdb;'"
  EOF
}

resource "google_compute_instance" "pg_duckdb" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = var.disk_size_gb
      type  = "pd-ssd"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    dynamic "access_config" {
      for_each = var.enable_public_ip ? [1] : []
      content {
        // Ephemeral public IP
      }
    }
  }

  metadata = {
    startup-script = local.startup_script
  }

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  allow_stopping_for_update = true

  tags = concat(["pg-duckdb"], var.additional_tags)

  metadata_startup_script = local.startup_script
}

# Firewall rule for PostgreSQL access
resource "google_compute_firewall" "pg_duckdb" {
  name    = "${var.instance_name}-pg"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_ranges = var.allowed_source_ranges
  target_tags   = ["pg-duckdb"]
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.37.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# VPC Network
resource "google_compute_network" "clickhouse" {
  name                            = "clickhouse-network"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = false
  routing_mode                    = "REGIONAL"
}

resource "google_compute_subnetwork" "clickhouse" {
  name          = "clickhouse-subnet"
  ip_cidr_range = var.subnet_cidr
  network       = google_compute_network.clickhouse.id
  region        = var.region

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.secondary_cidr_services
  }
}

# Firewall rules
resource "google_compute_firewall" "clickhouse_internal" {
  name    = "clickhouse-internal"
  network = google_compute_network.clickhouse.name

  allow {
    protocol = "tcp"
    ports    = ["8123", "9000", "9009", "9440", "2181", "2888", "3888"]
  }

  source_ranges = [var.subnet_cidr]
  target_tags   = ["clickhouse"]
}

resource "google_compute_firewall" "clickhouse_external" {
  name    = "clickhouse-external"
  network = google_compute_network.clickhouse.name

  allow {
    protocol = "tcp"
    ports    = ["8123", "9000"]
  }

  source_ranges = var.allowed_source_ranges
  target_tags   = ["clickhouse"]
}

# Instance template
resource "google_compute_instance_template" "clickhouse" {
  name_prefix  = "clickhouse-template-"
  machine_type = var.machine_type
  region       = var.region

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
    disk_size_gb = var.boot_disk_size_gb
    disk_type    = "pd-ssd"
  }

  disk {
    auto_delete  = true
    boot         = false
    disk_size_gb = var.data_disk_size_gb
    disk_type    = "pd-ssd"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.clickhouse.id

    dynamic "access_config" {
      for_each = var.assign_public_ip ? [1] : []
      content {
        // Ephemeral public IP
      }
    }
  }

  metadata = {
    startup-script = file("${path.module}/startup.sh")
  }

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  tags = ["clickhouse"]

  lifecycle {
    create_before_destroy = true
  }
}

# Managed Instance Group
resource "google_compute_region_instance_group_manager" "clickhouse" {
  name = "clickhouse-mig"

  base_instance_name = "clickhouse"
  region             = var.region
  target_size        = var.instance_count

  version {
    instance_template = google_compute_instance_template.clickhouse.id
  }

  named_port {
    name = "http"
    port = 8123
  }

  named_port {
    name = "native"
    port = 9000
  }

  update_policy {
    type                         = "PROACTIVE"
    minimal_action               = "REPLACE"
    max_surge_fixed              = 1
    max_unavailable_fixed        = 0
    replacement_method           = "SUBSTITUTE"
    instance_redistribution_type = "PROACTIVE"
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.clickhouse.id
    initial_delay_sec = 300
  }
}

# Health check
resource "google_compute_health_check" "clickhouse" {
  name                = "clickhouse-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10

  tcp_health_check {
    port = "8123"
  }
}

# Internal Load Balancer
resource "google_compute_region_backend_service" "clickhouse" {
  name                  = "clickhouse-backend"
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  protocol              = "TCP"
  health_checks         = [google_compute_health_check.clickhouse.id]

  backend {
    group = google_compute_region_instance_group_manager.clickhouse.instance_group
  }
}

resource "google_compute_forwarding_rule" "clickhouse" {
  name                  = "clickhouse-forwarding-rule"
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.clickhouse.id
  ports                 = ["8123", "9000"]
  network               = google_compute_network.clickhouse.id
  subnetwork            = google_compute_subnetwork.clickhouse.id
  allow_global_access   = true
}

# Outputs
output "ilb_ip" {
  description = "Internal Load Balancer IP address"
  value       = google_compute_forwarding_rule.clickhouse.ip_address
}

output "ilb_ip" {
  description = "Internal Load Balancer IP address"
  value       = google_compute_forwarding_rule.clickhouse.ip_address
}

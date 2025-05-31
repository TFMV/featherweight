terraform {
  required_providers {
    clickhouse = {
      source  = "ClickHouse/clickhouse"
      version = "~> 3.3.0"
    }
  }
}

provider "clickhouse" {
  organization_id = var.organization_id
  token_key       = var.token_key
  token_secret    = var.token_secret
}

resource "clickhouse_service" "benchmark" {
  name           = var.service_name
  cloud_provider = "aws"
  region         = var.region
  tier           = var.service_type

  min_replica_memory_gb = 8
  max_replica_memory_gb = 16

  endpoints = {
    mysql = {
      enabled = true
    }
    nativesecure = {
      enabled = true
    }
  }

  ip_access = [
    {
      source      = var.allowed_cidr
      description = "Allow access from specified CIDR"
    }
  ]
}

resource "clickhouse_database" "benchmark" {
  name       = "benchmark"
  service_id = clickhouse_service.benchmark.id
}

# Output connection details
output "connection_string" {
  value     = clickhouse_service.benchmark.endpoints["nativesecure"].host
  sensitive = true
}

output "service_id" {
  value = clickhouse_service.benchmark.id
}

output "endpoints" {
  value     = clickhouse_service.benchmark.endpoints
  sensitive = true
}

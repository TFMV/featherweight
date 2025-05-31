# Featherweight Infrastructure as Code

This directory contains the Infrastructure as Code (IAC) configurations for the Featherweight benchmark comparison between pg_duckdb and ClickHouse.

## Directory Structure

```
iac/
├── environments/
│   ├── pg_duckdb/           # GCE setup for pg_duckdb
│   ├── clickhouse_cloud/    # ClickHouse Cloud setup via Terraform provider
│   └── clickhouse_gcp/      # Self-hosted ClickHouse on GCP
├── modules/
│   ├── gce/                 # GCE instance module
│   ├── clickhouse/          # ClickHouse cluster module
│   ├── monitoring/          # Monitoring and logging module
│   └── network/             # Network configuration module
└── shared/                  # Shared configurations and variables
```

## Prerequisites

1. Required CLIs and authentication:
   - Google Cloud SDK
   - OpenTofu CLI (v1.6.0 or later)
   - ClickHouse Cloud API key (for managed service)
   - `gcloud` authentication with appropriate permissions

2. Environment variables:

   ```bash
   export CLICKHOUSE_CLOUD_API_KEY="your_api_key"  # For ClickHouse Cloud
   export GOOGLE_PROJECT="your_project_id"         # For GCP resources
   ```

## Quick Start

1. Choose your deployment type:

   a. For pg_duckdb:

   ```bash
   cd environments/pg_duckdb
   tofu init
   tofu apply
   ```

   b. For ClickHouse Cloud (managed):

   ```bash
   cd environments/clickhouse_cloud
   tofu init
   tofu apply
   ```

   c. For self-hosted ClickHouse:

   ```bash
   cd environments/clickhouse_gcp
   tofu init
   tofu apply
   ```

## Environment Details

### pg_duckdb Environment

- GCE instance optimized for analytical workloads
- PostgreSQL 15+ with pg_duckdb extension
- Direct access to cloud storage for external tables
- Monitoring and logging setup

### ClickHouse Cloud Environment

- Managed ClickHouse service
- Automatic scaling and maintenance
- Built-in monitoring and logging
- Network security and IAM integration

### Self-hosted ClickHouse Environment

- GCE instances for ClickHouse cluster
- ZooKeeper ensemble for coordination
- Custom monitoring and metrics
- Network configuration for high availability

## Variables

Each environment has its own `terraform.tfvars` file. Common variables include:

```hcl
# pg_duckdb
instance_type = "n2-standard-8"
disk_size_gb = 100
postgres_version = "15"

# clickhouse_cloud
service_type = "production"  # or "development"
region = "us-east"
compute_size = "8_64"  # 8 vCPU, 64GB RAM

# clickhouse_gcp
cluster_size = 3
instance_type = "n2-standard-8"
disk_type = "pd-ssd"
```

## Monitoring

Included monitoring features:

- Cloud Monitoring dashboards
- Query performance metrics
- Resource utilization tracking
- Cost analysis and optimization
- Custom alerting rules

## Security

- Private networking with VPC
- Cloud IAM integration
- TLS encryption for all connections
- Regular security scanning
- Audit logging

## Cost Management

Estimated monthly costs (US regions):

- pg_duckdb: $200-500 (depends on instance size)
- ClickHouse Cloud: $500-2000 (depends on usage)
- Self-hosted ClickHouse: $600-1500 (3-node cluster)

See individual environment READMEs for detailed cost breakdowns and optimization strategies.

## Limitations

### ClickHouse Cloud

- Limited customization of underlying infrastructure
- Region availability may be restricted
- Some features require Enterprise tier

### Self-hosted ClickHouse

- Requires more operational overhead
- Manual scaling and maintenance
- Complex backup and recovery procedures

### pg_duckdb

- Single-node deployment
- Shared resources with PostgreSQL
- Limited by instance memory

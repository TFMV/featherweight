# Featherweight Infrastructure as Code

This directory contains the Infrastructure as Code (IAC) configurations for the Featherweight benchmark comparison between pg_duckdb and AlloyDB.

## Directory Structure

```
iac/
├── environments/
│   ├── pg_duckdb/    # GCE/GKE setup for pg_duckdb
│   └── alloydb/      # AlloyDB managed service setup
├── modules/
│   ├── gce/          # GCE instance module
│   ├── gke/          # GKE cluster module
│   ├── alloydb/      # AlloyDB cluster module
│   └── monitoring/   # Monitoring and logging module
└── shared/           # Shared configurations and variables
```

## Prerequisites

1. Google Cloud SDK installed and configured
2. OpenTofu CLI installed (v1.6.0 or later)
3. `gcloud` authentication set up with appropriate permissions

## Quick Start

1. Set up your Google Cloud project:

   ```bash
   gcloud config set project YOUR_PROJECT_ID
   ```

2. Enable required APIs:

   ```bash
   gcloud services enable \
     compute.googleapis.com \
     container.googleapis.com \
     alloydb.googleapis.com \
     monitoring.googleapis.com
   ```

3. Initialize OpenTofu:

   ```bash
   cd environments/pg_duckdb  # or alloydb
   tofu init
   ```

4. Apply the configuration:

   ```bash
   tofu apply
   ```

## Environment Details

### pg_duckdb Environment

- GCE instance or GKE cluster (configurable)
- PostgreSQL 15+ with pg_duckdb extension
- Monitoring and logging setup
- Network configuration for benchmarking

### AlloyDB Environment

- Managed AlloyDB cluster
- Primary and read pool instances
- Columnar cache configuration
- Monitoring integration

## Variables

Each environment has its own `terraform.tfvars` file for configuration. See the README in each environment directory for specific variables.

## Monitoring

Both environments include:

- Cloud Monitoring dashboards
- Custom metrics for benchmarking
- Log exports and analysis
- Cost tracking

## Security

- All instances use private IP networking
- IAM configuration for least privilege
- Encryption at rest and in transit
- Audit logging enabled

## Cost Management

Estimated costs and optimization recommendations are documented in each environment's README.

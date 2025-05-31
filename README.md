# 🪶 Featherweight

Featherweight is a comprehensive benchmark suite comparing the performance, ergonomics, and cost-effectiveness of two analytical database solutions:

- **pg_duckdb**: DuckDB embedded in PostgreSQL via extension, bringing lightning-fast analytics to your existing PostgreSQL deployment
- **ClickHouse**: A high-performance columnar OLAP database system designed for real-time analytics at scale

## Overview

This benchmark focuses on five key dimensions:

1. **Large-scale Analytics**: Testing query performance on TPC-DS and real-world datasets
2. **Mixed OLTP/OLAP Workloads**: Evaluating performance on hybrid transactional/analytical scenarios
3. **External Data Processing**: Comparing Parquet/CSV/JSON handling capabilities
4. **Time-series Analytics**: Measuring performance on high-cardinality time-series data
5. **Operational Complexity**: Assessing deployment, maintenance, and scaling characteristics

## Repository Structure

```text
featherweight/
├── iac/                # Infrastructure as Code (OpenTofu/Terraform)
│   ├── environments/   # Environment-specific configurations
│   │   ├── pg_duckdb/ # PostgreSQL + pg_duckdb setup
│   │   └── clickhouse/# ClickHouse cluster configuration
│   └── modules/       # Reusable infrastructure modules
├── benchmark/         # Benchmark scripts and datasets
│   ├── tpcds/        # TPC-DS benchmark suite
│   ├── timeseries/   # Time-series workload tests
│   └── hybrid/       # Mixed OLTP/OLAP scenarios
├── art/              # Documentation and research materials
│   ├── article.md    # In-depth technical comparison
│   └── research/     # Background research and findings
└── monitoring/       # Prometheus + Grafana dashboards
```

## Getting Started

1. Set up infrastructure:

   ```bash
   cd iac/environments/pg_duckdb  # or clickhouse
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   tofu init && tofu apply
   ```

2. Run benchmarks:

   ```bash
   # Install dependencies
   pip install -r requirements.txt

   # Run specific benchmark suite
   python benchmark/runner.py --suite tpcds --scale-factor 100
   ```

## Key Features

- **Reproducible Environment**: Identical test setups via Infrastructure as Code
- **Comprehensive Metrics**:
  - Query execution time and resource utilization
  - Memory consumption patterns
  - I/O characteristics
  - Cost per query/TB
- **Real-world Workloads**: Based on practical analytics scenarios
- **Cost Analysis**:
  - Infrastructure costs
  - Query-level pricing
  - Storage efficiency (compression ratios)
  - Operational overhead

## Infrastructure as Code

Our infrastructure is managed using Terraform/OpenTofu with support for two deployment options:

### ClickHouse Deployment Options

1. **ClickHouse Cloud (Managed Service)**
   - Fully managed ClickHouse service
   - Automatic scaling and maintenance
   - Built-in monitoring and backups
   - Configuration:
     - Development or Production tier options
     - Configurable memory and compute resources
     - Secure access via IP allowlisting
     - MySQL and Native protocol support

2. **Self-hosted on GCP**
   - Regional Managed Instance Group deployment
   - High availability with auto-healing
   - Features:
     - Internal Load Balancing
     - Private networking with optional public access
     - Separate boot and data disks
     - Automatic instance recovery
     - Zero-downtime updates
   - Security:
     - Deletion protection enabled by default
     - Optional confidential computing
     - Service account-based authentication
     - Configurable firewall rules

### Infrastructure Management

- **Version Control**: All infrastructure code is version controlled
- **Environment Separation**: Distinct configurations for different environments
- **Security Best Practices**:
  - Least privilege service accounts
  - Network isolation
  - Encryption at rest and in transit
- **Monitoring Integration**: Built-in health checks and monitoring endpoints
- **Cost Optimization**:
  - Right-sized instances
  - Automatic scaling capabilities
  - Resource cleanup policies

### Deployment Requirements

#### ClickHouse Cloud

- Organization ID
- API Token Key/Secret
- Service name
- Allowed CIDR ranges

#### GCP Self-hosted

- GCP Project ID
- Service Account with required permissions
- Network configuration (CIDR ranges)
- Optional: Custom machine types and disk sizes

## Benchmark Scenarios

1. **Analytical Performance**
   - TPC-DS queries at various scale factors
   - Complex aggregations and joins
   - Window function performance

2. **Data Lake Integration**
   - External table performance
   - Parquet read/write speeds
   - Schema evolution handling

3. **Operational Metrics**
   - Deployment complexity
   - Maintenance overhead
   - Monitoring and observability
   - Backup and recovery

## Contributing

Featherweight is designed to be extended. We welcome contributions:

- Additional benchmark scenarios
- Infrastructure optimizations
- Documentation improvements
- Performance tuning insights

## License

MIT

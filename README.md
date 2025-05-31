# 🪶 Featherweight

Featherweight is a comprehensive benchmark suite comparing the performance, ergonomics, and cost-effectiveness of two PostgreSQL-native analytics solutions:

- **pg_duckdb**: DuckDB embedded in PostgreSQL via extension
- **AlloyDB**: Google Cloud's managed PostgreSQL fork with columnar acceleration

## Overview

This benchmark focuses on four key dimensions:

1. **Large Parquet OLAP Queries**: Testing analytical performance on large datasets
2. **JSON & Nested Struct Manipulation**: Comparing complex data type handling
3. **Time-series Aggregations & Filtering**: Evaluating time-series analytics capabilities
4. **Bulk Data-load & Snapshot Creation**: Measuring data ingestion and export performance

## Repository Structure

```
featherweight/
├── iac/              # Infrastructure as Code (OpenTofu/Terraform)
│   ├── environments/ # Environment-specific configurations
│   └── modules/      # Reusable infrastructure modules
├── benchmark/        # Benchmark scripts and datasets
└── art/             # Documentation and research materials
```

## Getting Started

1. Set up infrastructure:

   ```bash
   cd iac/environments/pg_duckdb  # or alloydb
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   tofu init && tofu apply
   ```

2. Run benchmarks:

   ```bash
   # Coming soon
   ```

## Key Features

- **Reproducible Environment**: Identical test setups via IAC
- **Comprehensive Metrics**: CPU, memory, I/O, and cost tracking
- **Real-world Workloads**: Based on practical analytics scenarios
- **Cost Analysis**: Includes "time-to-first-insight" and query-level pricing

## Contributing

Featherweight is designed to be extended. Feel free to:

- Add new benchmark scenarios
- Contribute optimizations
- Share your findings

## License

MIT

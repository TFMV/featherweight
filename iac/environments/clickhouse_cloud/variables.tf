variable "clickhouse_cloud_api_key" {
  description = "ClickHouse Cloud API key"
  type        = string
  sensitive   = true
}

variable "organization_id" {
  description = "ClickHouse Cloud organization ID"
  type        = string
  sensitive   = true
}

variable "token_key" {
  description = "ClickHouse Cloud API token key"
  type        = string
  sensitive   = true
}

variable "token_secret" {
  description = "ClickHouse Cloud API token secret"
  type        = string
  sensitive   = true
}

variable "service_name" {
  description = "Name of the ClickHouse service"
  type        = string
}

variable "region" {
  description = "Region for ClickHouse Cloud service"
  type        = string
  default     = "us-east-1"
}

variable "service_type" {
  description = "Type of ClickHouse Cloud service (production or development)"
  type        = string
  default     = "development"
}

variable "compute_size" {
  description = "Compute size for ClickHouse service (e.g., '8_64' for 8 vCPU, 64GB RAM)"
  type        = string
  default     = "8_64"
}

variable "storage_size_gb" {
  description = "Storage size in GB"
  type        = number
  default     = 100
}

variable "vpc_cidr" {
  description = "CIDR block for VPC access"
  type        = string
  default     = "10.0.0.0/16"
}

variable "allowed_ips" {
  description = "List of allowed IP addresses"
  type        = list(string)
  default     = []
}

variable "allowed_cidr" {
  description = "CIDR block allowed to access the ClickHouse service"
  type        = string
  default     = "0.0.0.0/0"
}

# Optional: Add more variables as needed for customization
variable "additional_tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}

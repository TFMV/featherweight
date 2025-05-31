variable "cluster_id" {
  description = "The ID to use for the AlloyDB cluster"
  type        = string
}

variable "location" {
  description = "The GCP location where the cluster will be created"
  type        = string
}

variable "network" {
  description = "The VPC network to use for the cluster"
  type        = string
}

variable "ip_range" {
  description = "The IP range to use for the cluster"
  type        = string
}

variable "database_password" {
  description = "The password for the database user"
  type        = string
  sensitive   = true
}

variable "database_user" {
  description = "The username for the database user"
  type        = string
  default     = "postgres"
}

variable "primary_cpu_count" {
  description = "The number of CPUs for the primary instance"
  type        = number
  default     = 8
}

variable "read_pool_cpu_count" {
  description = "The number of CPUs for each read pool instance"
  type        = number
  default     = 8
}

variable "read_pool_node_count" {
  description = "The number of nodes in the read pool"
  type        = number
  default     = 2
}

variable "columnar_cache_size_mb" {
  description = "The size of the columnar cache in MB"
  type        = number
  default     = 8192 # 8GB
}

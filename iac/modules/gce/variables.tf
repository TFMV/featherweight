variable "instance_name" {
  description = "The name of the GCE instance"
  type        = string
}

variable "machine_type" {
  description = "The machine type to use for the instance"
  type        = string
  default     = "n2-standard-8" # 8 vCPUs, 32GB memory
}

variable "zone" {
  description = "The zone where the instance will be created"
  type        = string
}

variable "disk_size_gb" {
  description = "The size of the boot disk in GB"
  type        = number
  default     = 100
}

variable "network" {
  description = "The VPC network to use for the instance"
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork to use for the instance"
  type        = string
}

variable "enable_public_ip" {
  description = "Whether to enable a public IP for the instance"
  type        = bool
  default     = false
}

variable "service_account_email" {
  description = "The service account email to use for the instance"
  type        = string
}

variable "additional_tags" {
  description = "Additional network tags to apply to the instance"
  type        = list(string)
  default     = []
}

variable "allowed_source_ranges" {
  description = "The source IP ranges that can access PostgreSQL"
  type        = list(string)
  default     = ["10.0.0.0/8"] # Default to internal network only
}

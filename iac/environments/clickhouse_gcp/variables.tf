variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "The region to deploy resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The zone to deploy resources"
  type        = string
  default     = "us-central1-a"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "secondary_cidr_services" {
  description = "CIDR range for secondary IP range used by services"
  type        = string
  default     = "10.1.0.0/24"
}

variable "allowed_source_ranges" {
  description = "List of CIDR ranges allowed to access ClickHouse"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "machine_type" {
  description = "Machine type for ClickHouse instances"
  type        = string
  default     = "n2-standard-4"
}

variable "boot_disk_size_gb" {
  description = "Size of the boot disk in GB"
  type        = number
  default     = 50
}

variable "data_disk_size_gb" {
  description = "Size of the data disk in GB"
  type        = number
  default     = 100
}

variable "instance_count" {
  description = "Number of ClickHouse instances to deploy"
  type        = number
  default     = 3
}

variable "assign_public_ip" {
  description = "Whether to assign public IPs to instances"
  type        = bool
  default     = false
}

variable "service_account_email" {
  description = "Service account email for ClickHouse instances"
  type        = string
}

variable "labels" {
  description = "Labels to apply to all resources"
  type        = map(string)
  default = {
    environment = "production"
    managed_by  = "terraform"
  }
}

variable "deletion_protection" {
  description = "Enable deletion protection for instances"
  type        = bool
  default     = true
}

variable "enable_confidential_computing" {
  description = "Enable confidential computing on instances"
  type        = bool
  default     = false
}

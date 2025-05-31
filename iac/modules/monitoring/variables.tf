variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "instance_id" {
  description = "The ID of the instance to monitor"
  type        = string
}

variable "location" {
  description = "The location for BigQuery dataset"
  type        = string
}

variable "owner_email" {
  description = "The email of the dataset owner"
  type        = string
}

variable "reader_email" {
  description = "The email of the dataset reader"
  type        = string
}

variable "notification_channels" {
  description = "The list of notification channel IDs"
  type        = list(string)
  default     = []
}

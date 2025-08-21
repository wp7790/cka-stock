variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-east1"
}

variable "node_count" {
  description = "Number of GKE nodes"
  type        = number
  default     = 2
}

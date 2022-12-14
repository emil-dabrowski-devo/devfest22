variable "app_name" {
  type        = string
  description = "Application name"
}

variable "env" {
  type        = string
  description = "Envineronment type"
}

variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "dns_project" {
  description = "Project name where DNS zones are managed."
  type        = string
}

variable "dns_zone" {
  description = "DNS zone name where DNS records are placed."
  default     = "demo"
}

variable "app_port" {
  description = "Application port"
}

variable "instance_groups" {
  description = "Created instance groups for LB to balance to"
}

variable "health_check_port" {
  description = "Port number for healthcheck"
}

variable "custom_labels" {
  description = "A map of custom labels to apply to the resources. The key is the label name and the value is the label value."
  type        = map(string)
  default     = {}
}

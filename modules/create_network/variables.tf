variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "network_name" {
  description = "The name of the network"
  type        = string
}

variable "scopes" {
  description = "Region for subnet"
  type        = map(any)
}

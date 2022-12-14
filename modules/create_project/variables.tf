variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "parent_folder" {
  description = "Parent folder"
  type        = string
}

variable "random" {
  description = "random"
  type        = bool
  default     = true
}

variable "billing_id" {
  description = "Billing account ID"
  type        = string
}

variable "apis_enable" {
  description = "List of apis to be enabled"
  type        = set(string)
  default = [
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iap.googleapis.com"
  ]
}
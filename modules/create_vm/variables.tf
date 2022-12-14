variable "app_name" {
  type        = string
  description = "Application name"
}

variable "env" {
  description = "Envineronment type"
  type        = string
}

variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "tags" {
  description = "Additional tags"
  default     = []
}

variable "network_subnet" {
  description = "SSubnet where network resources should be deployed"
}

variable "dns_project" {
  description = "Project name where DNS zones are managed."
  default     = "" #REPLACE
}

variable "dns_zone" {
  description = "DNS zone name where DNS records are placed."
  default     = "" #REPLACE
}

variable "region" {
  description = "Name of region where instances and unmanaged group should be deployed"
}

variable "app_ports" {
  description = "Named name and named port"
}

variable "num_instances" {
  description = "Number of instances in zone."
}

variable "machine_type" {
  description = "Machine type to create, e.g. g1-small (1CPU/1.7G RAM), n1-standard-1 (1CPU/3.75G RAM), e2-custom-16-32768 (16CPU / 32G RAM"
}

variable "can_ip_forward" {
  description = "Enable IP forwarding, for NAT instances for example"
  default     = "false"
}

variable "auto_delete" {
  description = "Whether or not the boot disk should be auto-deleted"
  default     = "true"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  default     = "10"
}

variable "disk_type" {
  description = "Boot disk type, can be either pd-ssd, local-ssd, or pd-standard"
  default     = "pd-standard"
}

variable "on_host_maintenance" {
  type        = string
  description = "Instance availability Policy"
  default     = "MIGRATE"
}

variable "network_id" {
  description = "Network ID"
  type        = string
}

variable "startup_script" {
  description = "starup script"
  type        = string
  default     = <<SCRIPT
    apt update
    apt -y install apache2
    cat <<EOF > /var/www/html/index.html
    <html><body><p>This is devfest22 demo machine</p></body></html>
  SCRIPT

}

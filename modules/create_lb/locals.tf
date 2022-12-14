locals {
  fqdn = var.env != "prod" ? "${var.app_name}-${var.env}.${data.google_dns_managed_zone.dns.dns_name}" : "www.${data.google_dns_managed_zone.dns.dns_name}"
}
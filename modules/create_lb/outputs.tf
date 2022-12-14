output "lb_ip" {
  value = google_compute_global_address.address.address
}

output "lb_fqdn" {
  value = google_dns_record_set.lb.name
}
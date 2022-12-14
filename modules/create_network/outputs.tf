output "network_id" {
  value = google_compute_network.vpc_network.id
}

output "subnets" {
  value = local.subnets_list
}

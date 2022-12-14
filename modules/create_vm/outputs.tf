output "instance_groups" {
  value = google_compute_instance_group.ig[*]
}

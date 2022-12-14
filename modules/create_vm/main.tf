locals {
  ports      = [for i in local.named_ports : i.port if i.service == "lb"]
  backup_tag = ["nt-${var.app_name}-${var.region}"]

  named_ports = flatten([for service, ports in var.app_ports : [
    for port in ports : {
      service = service
      name    = "${var.app_name}-${service}-${port}"
      port    = port
    }
    ]]
  )
}

data "google_dns_managed_zone" "dns" {
  project = var.dns_project
  name    = var.dns_zone
}

data "google_compute_image" "my_image" {
  family  = "debian-11"
  project = "debian-cloud"
}

resource "google_compute_instance" "instance" {
  count                     = var.num_instances
  project                   = var.project_id
  name                      = format("${var.app_name}-%03d", count.index + 1)
  zone                      = "${var.region}-b"
  machine_type              = var.machine_type
  allow_stopping_for_update = true
  tags                      = concat(local.backup_tag, var.tags)
  can_ip_forward            = var.can_ip_forward
  metadata_startup_script   = var.startup_script


  boot_disk {
    auto_delete = var.auto_delete
    initialize_params {
      image = data.google_compute_image.my_image.self_link
      size  = var.disk_size_gb
      type  = var.disk_type
    }
  }

  network_interface {
    subnetwork = var.network_subnet
  }

  scheduling {
    on_host_maintenance = var.on_host_maintenance
  }

}

# resource "google_dns_record_set" "instance" {
#   count   = var.num_instances
#   project = var.dns_project
#   name    = format("${var.env}-${var.app_name}-%03d.${data.google_dns_managed_zone.dns.dns_name}", count.index + 1)
#   type    = "A"
#   ttl     = 300

#   managed_zone = data.google_dns_managed_zone.dns.name

#   rrdatas = [google_compute_instance.instance[count.index].network_interface.0.network_ip]
# }

resource "google_compute_instance_group" "ig" {
  name      = "ig-${var.app_name}-${var.region}"
  zone      = "${var.region}-b"
  project   = var.project_id
  instances = google_compute_instance.instance.*.self_link
  dynamic "named_port" {
    for_each = local.named_ports
    content {
      name = lookup(named_port.value, "name", null)
      port = lookup(named_port.value, "port", null)
    }
  }
}

resource "google_compute_firewall" "ingress_rule" {
  name        = "fw-${var.app_name}-lb-access"
  network     = var.network_id
  project     = var.project_id
  description = "Firewall rule for ${var.app_name} Load Balancer access"
  allow {
    protocol = "tcp"
    ports    = toset(local.ports)
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = var.tags
}

resource "google_compute_firewall" "backup_upstreams" {
  name        = "fw-${var.app_name}-bck-upstream"
  network     = var.network_id
  project     = var.project_id
  description = "Firewall rule for backup upstreams access on ${var.app_name} targeting tagged instances"

  allow {
    protocol = "tcp"
    ports    = var.app_ports["backup"]
  }
  source_tags = local.backup_tag
  target_tags = local.backup_tag
}
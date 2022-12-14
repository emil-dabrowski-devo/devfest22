resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = var.network_name
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "vpc_subnet" {
  for_each      = var.scopes
  name          = "${each.key}-subnetwork"
  project       = var.project_id
  ip_cidr_range = each.value
  region        = each.key
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_router" "router" {
  for_each = var.scopes
  name     = "${each.key}-router"
  project  = var.project_id
  region   = each.key
  network  = google_compute_network.vpc_network.id
}

resource "google_compute_router_nat" "nat" {
  for_each                           = var.scopes
  name                               = "${each.key}-nat"
  project                            = var.project_id
  region                             = each.key
  router                             = google_compute_router.router[each.key].name
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"
}

resource "google_compute_firewall" "inbound-ip-ssh" {
  name    = "allow-incoming-ssh-from-iap"
  project = var.project_id
  network = google_compute_network.vpc_network.id

  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = [
    "35.235.240.0/20"
  ]
}
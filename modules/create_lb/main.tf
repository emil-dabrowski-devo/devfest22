data "google_dns_managed_zone" "dns" {
  project = var.dns_project
  name    = var.dns_zone
}

resource "google_compute_health_check" "hc" {
  project             = var.project_id
  name                = "hc-${var.app_name}-${var.env}-${var.health_check_port[0]}"
  check_interval_sec  = 5
  timeout_sec         = 3
  healthy_threshold   = 2
  unhealthy_threshold = 5

  tcp_health_check {
    port      = var.health_check_port[0]
    port_name = "${var.app_name}-${var.env}-hc"
  }

  log_config {
    enable = true
  }
}

resource "google_compute_backend_service" "be" {
  project               = var.project_id
  name                  = "be-${var.app_name}-${var.env}-${var.health_check_port[0]}"
  protocol              = "HTTP"
  port_name             = "${var.app_name}-${var.env}-lb-80"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_health_check.hc.id]

  dynamic "backend" {
    for_each = var.instance_groups
    content {
      group           = backend.value.id
      balancing_mode  = "UTILIZATION"
      max_utilization = 0.9
    }
  }
}

resource "google_compute_global_address" "address" {
  project      = var.project_id
  name         = "ra-${var.app_name}-${var.env}"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}

resource "google_compute_url_map" "url_map" {
  project         = var.project_id
  name            = "lb-${var.app_name}-${var.env}"
  description     = "URL map for ${var.app_name}"
  default_service = google_compute_backend_service.be.self_link
}

resource "google_compute_target_http_proxy" "http" {
  project = var.project_id
  name    = "${var.app_name}-http-proxy"
  url_map = google_compute_url_map.url_map.id
}


resource "google_compute_global_forwarding_rule" "http" {
  project    = var.project_id
  name       = "${var.app_name}-http-rule"
  target     = google_compute_target_http_proxy.http.self_link
  ip_address = google_compute_global_address.address.address
  port_range = "80"
  labels     = var.custom_labels
}


resource "google_dns_record_set" "lb" {
  project = var.dns_project
  name    = local.fqdn
  type    = "A"
  ttl     = 300

  managed_zone = data.google_dns_managed_zone.dns.name

  rrdatas = [google_compute_global_address.address.address]
}

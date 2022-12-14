module "random_id" {
  source = "../helpers"
  random = var.random
}

resource "google_project_service" "api" {
  for_each = var.apis_enable
  project  = google_project.project.id
  service  = each.value
}

resource "google_project" "project" {
  name            = "${var.project_id}-${module.random_id.id}"
  project_id      = "${var.project_id}-${module.random_id.id}"
  folder_id       = var.parent_folder
  billing_account = var.billing_id
}
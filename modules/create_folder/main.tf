resource "google_folder" "main" {
  display_name = var.folder_name
  parent       = var.parent_folder_id
}
output "id" {
  value = split("/", google_project.project.id)[1]
}
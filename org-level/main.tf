module "create_parent" {
  source           = "../modules/create_folder"
  folder_name      = var.folder_name
  parent_folder_id = "folders/${var.parent_folder_id}"
}

module "create_policies" {
  source    = "../modules/create_policies"
  folder_id = module.create_parent.folder_id
}
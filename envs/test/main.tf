module "create_folder" {
  source           = "../../modules/create_folder"
  for_each         = var.apps
  parent_folder_id = local.parent_folder_id
  folder_name      = "test-${each.key}"
}

module "create_project" {
  source        = "../../modules/create_project"
  for_each      = var.apps
  parent_folder = module.create_folder[each.key].folder_id
  project_id    = each.key
  billing_id    = local.billing_id
}

module "create_network" {
  source       = "../../modules/create_network"
  for_each     = var.apps
  project_id   = module.create_project[each.key].id
  network_name = each.key
  scopes       = each.value
}

module "create_vm" {
  source         = "../../modules/create_vm"
  for_each       = var.vms
  app_name       = each.value.app_name
  env            = each.value.env
  project_id     = module.create_project[each.value.app_name].id
  network_subnet = module.create_network[each.value.app_name].subnets[each.value.region]
  network_id     = module.create_network[each.value.app_name].network_id
  app_ports = {
    "lb"     = [80],
    "hc"     = [80],
    "backup" = [8080]
  }
  num_instances = each.value.num_instances
  machine_type  = each.value.machine_type
  region        = each.value.region
}

module "create_lb" {
  source            = "../../modules/create_lb"
  for_each          = var.vms
  project_id        = module.create_project[each.value.app_name].id
  app_name          = each.value.app_name
  env               = each.value.env
  instance_groups   = local.instance_groups
  health_check_port = ["80"]
  app_port          = ["80"]
}
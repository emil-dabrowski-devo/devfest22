locals {
  parent_folder_id = data.terraform_remote_state.l1.outputs.parent_folder_id
  billing_id       = data.terraform_remote_state.l1.outputs.billing_id

  instance_groups = flatten([for region, data in module.create_vm : [
    for item in data.instance_groups :
    {
      "region"    = region,
      "zone"      = item.zone,
      "id"        = item.id,
      "self_link" = item.self_link
    }
  ]])
}

resource "google_folder_organization_policy" "compute_skip_default_network_creation" {
  folder     = var.folder_id
  constraint = "constraints/compute.skipDefaultNetworkCreation"

  boolean_policy {
    enforced = true
  }
}

resource "google_folder_organization_policy" "compute_vm_external_ip_access" {
  folder     = var.folder_id
  constraint = "constraints/compute.vmExternalIpAccess"

  list_policy {
    inherit_from_parent = false

    deny {
      all = true
    }
  }
}
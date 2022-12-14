variable "apps" {
  description = "Applications that should be run in env"
  type        = map(any)
  default = {
    "web" = {
      europe-west1    = "10.10.1.0/24"
      europe-central2 = "10.10.2.0/24"
    },
    "data" = {
      europe-west1 = "10.20.1.0/24"
    }
  }
}

variable "vms" {
  description = "Params for vms"
  type        = map(any)
  default = {
    "web-vm1" = {
      env           = "test"
      app_name      = "web"
      region        = "europe-west1"
      num_instances = 5
      machine_type  = "e2-small"
    }
  }
}
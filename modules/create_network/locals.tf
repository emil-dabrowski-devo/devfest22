locals {
  subnets_list = {
    for region, params in google_compute_subnetwork.vpc_subnet :
    region => params.id
  }
}
    
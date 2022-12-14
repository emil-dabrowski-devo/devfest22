locals {
  run_random    = var.random ? 1 : 0
  output_random = var.random ? resource.random_id.server[0].hex : "norandom"
}
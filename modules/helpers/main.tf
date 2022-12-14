resource "random_id" "server" {
  count       = local.run_random
  byte_length = 8
}
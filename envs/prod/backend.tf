terraform {
  backend "gcs" {
    bucket                      = "TF_BUCKET_ID" # REPLACE
    prefix                      = "prod"
    impersonate_service_account = "TF_SA" # REPLACE
  }
}

data "terraform_remote_state" "l1" {
  backend = "gcs"
  config = {
    bucket = "TF_BUCKET_ID" # REPLACE
    prefix = "org-level"
  }
  workspace = "default"
}
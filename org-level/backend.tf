terraform {
  backend "gcs" {
    bucket                      = "TF_BUCKET_ID" # REPLACE
    prefix                      = "org-level"
    impersonate_service_account = "TF_SA" # REPLACE
  }
}
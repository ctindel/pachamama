# Backend
terraform {
  backend "gcs" {
    bucket  = "terraform-prod-01"
    path = "/terraform.state"
    project = "terraform-prod-01"
  }
}

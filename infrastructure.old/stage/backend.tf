# Backend
terraform {
  backend "gcs" {
    bucket  = "terraform-stage-01"
    path = "/terraform.state"
    project = "terraform-stage-01"
  }
}

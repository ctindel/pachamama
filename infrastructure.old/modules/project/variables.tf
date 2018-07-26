variable "org_id" {}
variable "billing_account" {}
variable "region" {}
variable "project_name" {}

variable "project_services" {
  type = "list"
  default = [
    "oslogin.googleapis.com",
    "bigquery-json.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "pubsub.googleapis.com",
    "compute.googleapis.com",
    "deploymentmanager.googleapis.com",
    "replicapool.googleapis.com",
    "replicapoolupdater.googleapis.com",
    "resourceviews.googleapis.com",
    "container.googleapis.com",
    "storage-api.googleapis.com",
    "serviceusage.googleapis.com"
  ]
}

variable "editors" {
  type = "list"
  default = [
    "tomas@pachamama.io"
  ]
}

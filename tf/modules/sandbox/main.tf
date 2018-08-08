provider "google" {
    region = "${var.region}"
}

resource "random_id" "id" {
    byte_length = 4
    prefix      = "${var.username}-"
}

resource "google_project" "project" {
    name            = "${var.username}"
    project_id      = "${random_id.id.hex}"
    billing_account = "${var.billing_account}"
    org_id          = "${var.org_id}"
}

resource "google_project_services" "project" {
    project = "${google_project.project.project_id}"
    services = [
       "compute.googleapis.com",
       "cloudapis.googleapis.com",
       "storage-api.googleapis.com",
       "storage-component.googleapis.com",
       "datastore.googleapis.com",
    ]
}

resource "google_project_iam_member" "project" {
    project = "${google_project.project.project_id}"
    role    = "roles/editor"
    member  = "user:${var.owner_email}"
}


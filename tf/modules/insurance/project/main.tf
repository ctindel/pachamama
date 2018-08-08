provider "google" {
    region = "${var.region}"
}

#resource "random_id" "id" {
#    byte_length = 4
#    prefix      = "${var.name}-"
#}

resource "google_project" "project" {
    name            = "${var.name}"
    project_id      = "${var.name}"
    #project_id      = "${random_id.id.hex}"
    billing_account = "${var.billing_account}"
    org_id          = "${var.org_id}"
}

resource "google_project_services" "project" {
    project = "${google_project.project.project_id}"
    services = [
       "bigquery-json.googleapis.com",
       "cloudapis.googleapis.com",
       "clouddebugger.googleapis.com",
       "cloudresourcemanager.googleapis.com",
       "cloudtrace.googleapis.com",
       "compute.googleapis.com",
       "container.googleapis.com",
       "datastore.googleapis.com",
       "logging.googleapis.com",
       "monitoring.googleapis.com",
       "oslogin.googleapis.com",
       "servicemanagement.googleapis.com",
       "serviceusage.googleapis.com",
       "sql-component.googleapis.com",
       "storage-api.googleapis.com",
       "storage-component.googleapis.com"
    ]
}

resource "google_project_iam_member" "admin_group" {
    project = "${google_project.project.project_id}"
    role    = "roles/editor"
    member  = "group:${var.owner_group_email}"
}

resource "google_project_iam_member" "admin_service" {
    project = "${google_project.project.project_id}"
    role    = "roles/editor"
    member  = "serviceAccount:${var.service_account_email}"
}

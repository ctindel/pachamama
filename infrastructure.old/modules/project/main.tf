
resource "random_id" "project_id" {
  byte_length = 8
}

resource "google_project" "project" {
  name            = "${var.project_name}"
  project_id      = "project-${random_id.project_id.hex}"
  billing_account = "${var.billing_account}"
  org_id          = "${var.org_id}"
}

resource "google_project_services" "project_services" {
  project = "${google_project.project.project_id}"
  services = "${var.project_services}"
}

resource "google_project_iam_member" "editors" {
  count = "${length(var.editors)}"
  project = "${google_project.project.project_id}"
  role    = "roles/editor"
  member = "user:${element(var.editors, count.index)}"
}

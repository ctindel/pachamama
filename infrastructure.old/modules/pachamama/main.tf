
provider "google" {
  region = "${var.region}"
  project = "${var.project}"
}

module "insurance_project" {
  source          = "../project"
  org_id          = "${var.org_id}"
  billing_account = "${var.billing_account}"
  region          = "${var.region}"
  project_name    = "insurance-${var.environment}"
}

module "kubernetes" {
  source          = "../compute/kubernetes"
  project_id      = "${module.insurance_project.project_id}"
  name            = "${module.insurance_project.project_name}"
  node_count      = "1"
}

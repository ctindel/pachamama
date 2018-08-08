terraform {
  backend "gcs" {
  }
}

module "sandbox" {
  source          = "../../../modules/sandbox"
  username        = "${var.username}"
  owner_email     = "${var.owner_email}"
  region          = "${var.region}"
  billing_account = "01F975-11BF2C-6BC84D"
  org_id          = "924627718475"
}

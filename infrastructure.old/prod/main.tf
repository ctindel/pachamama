
module "pachamama" {
  source          = "../modules/pachamama"
  org_id          = "${var.org_id}"
  billing_account = "${var.billing_account}"
  region          = "${var.region}"
  project         = "${var.project}"
  environment     = "${var.environment}"
}

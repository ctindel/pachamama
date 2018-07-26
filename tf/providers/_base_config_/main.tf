module "project" {
  source          = "../../modules/project"
  name            = "${var.name}-${var.env}"
  region          = "${var.region}"
  #billing_account = "${var.billing_account}"
  #org_id          = "${var.org_id}"
}

module "network" {
  source                     = "../../modules/network"
  env                        = "${var.env}"
  name                       = "${var.name}-${var.env}"
  project                    = "${module.project.id}"
  region                     = "${var.region}"
  zones                      = "${var.zones}"
  internal_subnet_name       = "internal"
  internal_subnet_ip_range   = "${var.internal_subnet_ip_range}"
  management_subnet_name     = "management"
  management_subnet_ip_range = "${var.management_subnet_ip_range}"
  bastion_image              = "pachamama-${var.env}-ubuntu-base"
  bastion_instance_type      = "${var.bastion_instance_type}"
  #user                       = "${var.user}"
  #ssh_key                    = "${var.ssh_key}"
}

module "docker_registry" {
  source                     = "../../modules/docker_registry"
  env                        = "${var.env}"
  name                       = "${var.name}-${var.env}"
  project                    = "${module.project.id}"
  subnet                     = "${module.network.internal_subnet_self_link}"
  zones                      = "${var.zones}"
  instance_type              = "${var.docker_registry_instance_type}"
  #user                       = "${var.user}"
  #ssh_key                    = "${var.ssh_key}"
}

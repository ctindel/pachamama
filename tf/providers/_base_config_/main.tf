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
  internal_k8s_cluster_service_cidr_range = "${var.internal_k8s_cluster_service_cidr_range}"
  internal_k8s_pod_cidr_range = "${var.internal_k8s_pod_cidr_range}"
  management_subnet_name     = "management"
  management_subnet_ip_range = "${var.management_subnet_ip_range}"
  external_k8s_cluster_service_cidr_range = "${var.external_k8s_cluster_service_cidr_range}"
  external_k8s_pod_cidr_range = "${var.external_k8s_pod_cidr_range}"
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

module "gitlab" {
  source                     = "../../modules/gitlab"
  env                        = "${var.env}"
  name                       = "${var.name}-${var.env}"
  project                    = "${module.project.id}"
  subnet                     = "${module.network.internal_subnet_self_link}"
  zones                      = "${var.zones}"
  instance_type              = "${var.gitlab_instance_type}"
  #user                       = "${var.user}"
  #ssh_key                    = "${var.ssh_key}"
}

module "mongodb" {
  source                     = "../../modules/mongodb"
  env                        = "${var.env}"
  name                       = "${var.name}-${var.env}"
  project                    = "${module.project.id}"
  network                    = "${module.network.network_self_link}"
  subnet                     = "${module.network.internal_subnet_self_link}"
  zones                      = "${var.zones}"
  instance_type              = "${var.mongodb_instance_type}"
  #user                       = "${var.user}"
  #ssh_key                    = "${var.ssh_key}"
}

#module "external_k8s" {
#  source                     = "../../modules/k8s"
#  env                        = "${var.env}"
#  name                       = "${var.name}-${var.env}-management"
#  project                    = "${module.project.name}"
#  network                    = "${module.network.network_self_link}"
#  subnet                     = "${module.network.management_subnet_self_link}"
#  zones                      = "${var.zones}"
#  instance_type              = "${var.external_k8s_instance_type}"
#  instance_count             = "${var.external_k8s_instance_count}"
#  private_cluster            = false
#  master_ipv4_cidr_block     = "${var.external_k8s_master_k8s_ip_range}"
#}

# Can't get this to work.  Google just gives an unspecified error with 
#  literally zero error messages or debugging help
#module "internal_k8s" {
#  source                     = "../../modules/k8s"
#  env                        = "${var.env}"
#  name                       = "${var.name}-${var.env}-internal"
#  project                    = "${module.project.name}"
#  network                    = "${module.network.network_self_link}"
#  subnet                     = "${module.network.internal_subnet_self_link}"
#  zones                      = "${var.zones}"
#  instance_type              = "${var.internal_k8s_instance_type}"
#  instance_count             = "${var.internal_k8s_instance_count}"
#  private_cluster            = true
#  master_ipv4_cidr_block     = "${var.internal_k8s_master_k8s_ip_range}"
#}



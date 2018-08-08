terraform {
  backend "gcs" {
  }
}

module "project" {
  source            = "../../../modules/insurance/project"
  name              = "${var.name}-${var.env}"
  region            = "${var.region}"
  owner_group_email = "${var.owner_group_email}"
  service_account_email = "${var.service_account_email}"
  billing_account   = "01F975-11BF2C-6BC84D"
  org_id            = "924627718475"
}

module "network" {
  source                     = "../../../modules/insurance/network"
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
}

module "docker_registry" {
  source                     = "../../../modules/insurance/docker_registry"
  env                        = "${var.env}"
  name                       = "${var.name}-${var.env}"
  project                    = "${module.project.id}"
  subnet                     = "${module.network.internal_subnet_self_link}"
  zones                      = "${var.zones}"
  instance_type              = "${var.docker_registry_instance_type}"
}

#module "gitlab" {
#  source                     = "../../../modules/insurance/gitlab"
#  env                        = "${var.env}"
#  name                       = "${var.name}-${var.env}"
#  project                    = "${module.project.id}"
#  subnet                     = "${module.network.internal_subnet_self_link}"
#  zones                      = "${var.zones}"
#  instance_type              = "${var.gitlab_instance_type}"
#}
#
#module "mongodb" {
#  source                     = "../../../modules/insurance/mongodb"
#  env                        = "${var.env}"
#  name                       = "${var.name}-${var.env}"
#  project                    = "${module.project.id}"
#  network                    = "${module.network.network_self_link}"
#  subnet                     = "${module.network.internal_subnet_self_link}"
#  zones                      = "${var.zones}"
#  instance_type              = "${var.mongodb_instance_type}"
#}
#
#module "elasticsearch" {
#  source                     = "../../../modules/insurance/elasticsearch"
#  env                        = "${var.env}"
#  name                       = "${var.name}-${var.env}"
#  project                    = "${module.project.id}"
#  network                    = "${module.network.network_self_link}"
#  subnet                     = "${module.network.internal_subnet_self_link}"
#  zones                      = "${var.zones}"
#  instance_type              = "${var.elasticsearch_instance_type}"
#}
#
#module "k8s" {
#  source                     = "../../../modules/insurance/k8s"
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

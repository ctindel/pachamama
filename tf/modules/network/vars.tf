variable "env" {}
variable "name" {}
variable "project" {}
variable "region" {}
variable "zones" { type = "list" }
variable "internal_subnet_name" {}
variable "internal_subnet_ip_range" {}
variable "management_subnet_name" {}
variable "management_subnet_ip_range" {}
variable "bastion_image" {}
variable "bastion_instance_type" {}
#variable "user" {}
#variable "ssh_key" {}

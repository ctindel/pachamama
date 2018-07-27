variable "env" {
  description = "The environment name (dev | staging | prod)."
}

variable "name" {
  description = "The environment name; used as a prefix when naming resources."
}

variable "region" {
  description = "The google cloud region in which to run"
}

#variable "billing_account" {
#  description = "The google cloud billing account"
#}
#
#variable "org_id" {
#  description = "The google cloud organization ID"
#}

variable "zones" { 
    type = "list" 
    description = "A list of availability zones"
}

variable "internal_subnet_ip_range" { 
    description = "An IP range for use with internal systems"
}

variable "management_subnet_ip_range" { 
    description = "An IP range for use with management systems"
}

variable "bastion_instance_type" { 
    description = "Instance type to use for the bastion host"
}

variable "docker_registry_instance_type" { 
    description = "Instance type to use for the docker registry host"
}

variable "external_k8s_instance_type" { 
    description = "Instance type to use for the external k8s nodes"
}

variable "external_k8s_instance_count" { 
    description = "Number of instances to use for the external k8s nodes"
}

variable "external_k8s_master_k8s_ip_range" {
    description = "IP Range for Externally facing kubernetes cluster master"
}

variable "external_k8s_cluster_service_cidr_range" {
    description = "IP Range for Externally facing kubernetes cluster services"
}

variable "external_k8s_node_cidr_range" {
    description = "IP Range for Externally facing kubernetes cluster nodes"
}

variable "external_k8s_pod_cidr_range" {
    description = "IP Range for Externally facing kubernetes cluster pods"
}

variable "internal_k8s_instance_type" { 
    description = "Instance type to use for the internal k8s nodes"
}

variable "internal_k8s_instance_count" { 
    description = "Number of instances to use for the internal k8s nodes"
}

variable "internal_k8s_master_k8s_ip_range" {
    description = "IP Range for Internally facing kubernetes cluster master"
}

variable "internal_k8s_cluster_service_cidr_range" {
    description = "IP Range for Internally facing kubernetes cluster services"
}

variable "internal_k8s_node_cidr_range" {
    description = "IP Range for Internally facing kubernetes cluster nodes"
}

variable "internal_k8s_pod_cidr_range" {
    description = "IP Range for Internally facing kubernetes cluster pods"
}

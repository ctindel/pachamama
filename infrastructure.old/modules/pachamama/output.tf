output "insurance_project_id" {
  value = "${module.insurance_project.project_id}"
}

output "client_certificate" {
  value = "${module.kubernetes.client_certificate}"
}

output "client_key" {
  value = "${module.kubernetes.client_key}"
}

output "cluster_ca_certificate" {
  value = "${module.kubernetes.cluster_ca_certificate}"
}

output "name" {
  value = "${google_compute_network.network.name}"
}

output "management_subnet_self_link" {
  value = "${module.management_subnet.self_link}"
}

output "internal_subnet_self_link" {
  value = "${module.management_subnet.self_link}"
}

output "bastion_public_ip" {
  value = "${module.bastion.public_ip}"
}

output "gateway_ipv4"  {
  value = "${google_compute_network.network.gateway_ipv4}"
}

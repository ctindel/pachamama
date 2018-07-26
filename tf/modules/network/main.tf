resource "google_compute_network" "network" {
  name    = "${var.name}-network"
  project = "${var.project}"
}

resource "google_compute_firewall" "allow-internal" {
  name    = "${var.name}-allow-internal"
  project = "${var.project}"
  network = "${var.name}-network"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = [
    "${module.management_subnet.ip_range}",
    "${module.internal_subnet.ip_range}"
  ]
}

resource "google_compute_firewall" "allow-ssh-from-everywhere-to-bastion" {
  name    = "${var.name}-allow-ssh-from-everywhere-to-bastion"
  project = "${var.project}"
  network = "${var.name}-network"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["bastion"]
}

resource "google_compute_firewall" "allow-ssh-from-bastion-to-internal" {
  name               = "${var.name}-allow-ssh-from-bastion-to-internal"
  project            = "${var.project}"
  network            = "${var.name}-network"
  direction          = "EGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags        = ["ssh"]
}

resource "google_compute_firewall" "allow-ssh-to-internal-from-bastion" {
  name          = "${var.name}-allow-ssh-to-private-network-from-bastion"
  project       = "${var.project}"
  network       = "${var.name}-network"
  direction     = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags   = ["bastion"]
}

module "management_subnet" {
  source   = "./subnet"
  project  = "${var.project}"
  region   = "${var.region}"
  name     = "${var.management_subnet_name}"
  network  = "${google_compute_network.network.self_link}"
  ip_range = "${var.management_subnet_ip_range}"
}

module "internal_subnet" {
  source   = "./subnet"
  project  = "${var.project}"
  region   = "${var.region}"
  name     = "${var.internal_subnet_name}"
  network  = "${google_compute_network.network.self_link}"
  ip_range = "${var.internal_subnet_ip_range}"
}

module "bastion" {
  source        = "./bastion"
  name          = "${var.name}"
  project       = "${var.project}"
  zones         = "${var.zones}"
  subnet_name   = "${module.management_subnet.self_link}"
  image         = "${var.bastion_image}"
  instance_type = "${var.bastion_instance_type}"
#  user          = "${var.user}"
#  ssh_key       = "${var.ssh_key}"
}

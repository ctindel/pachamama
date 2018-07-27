resource "google_compute_firewall" "allow-elk" {
  name    = "${var.name}-allow-elk"
  project = "${var.project}"
  network = "${var.network}"

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

  source_tags = ["elk"]
  target_tags = ["elk"]
}

resource "google_compute_instance" "elk_one" {
  name                  = "elk1"
  project               = "${var.project}"
  machine_type = "${var.instance_type}"
  tags = ["elk"]
  zone = "${element(var.zones, 0)}"

  metadata {
    #ssh-keys = "${var.user}:${file("${var.ssh_key}")}"
    user-data = "${data.template_cloudinit_config.elk_user_data.rendered}"
  }

  boot_disk {
    initialize_params {
      image = "pachamama-${var.env}-ubuntu-base"
    }
  }

  network_interface {
    subnetwork = "${var.subnet}"

    # Need an ephemeral IP so apt-get can install the elk packages
    access_config {
      # Ephemeral IP - leaving this block empty will generate a new external IP and assign it to the machine
    }
  }

#  service_account {
#    scopes = ["storage-rw"]
#  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance" "elk_two" {
  name                  = "elk2"
  project               = "${var.project}"
  machine_type = "${var.instance_type}"
  tags = ["elk"]
  zone = "${element(var.zones, 0)}"

  metadata {
    #ssh-keys = "${var.user}:${file("${var.ssh_key}")}"
    user-data = "${data.template_cloudinit_config.elk_user_data.rendered}"
  }

  boot_disk {
    initialize_params {
      image = "pachamama-${var.env}-ubuntu-base"
    }
  }

  network_interface {
    subnetwork = "${var.subnet}"

    # Need an ephemeral IP so apt-get can install the elk packages
    access_config {
      # Ephemeral IP - leaving this block empty will generate a new external IP and assign it to the machine
    }
  }

#  service_account {
#    scopes = ["storage-rw"]
#  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance" "elk_three" {
  name                  = "elk3"
  project               = "${var.project}"
  machine_type = "${var.instance_type}"
  tags = ["elk"]
  zone = "${element(var.zones, 0)}"

  metadata {
    #ssh-keys = "${var.user}:${file("${var.ssh_key}")}"
    user-data = "${data.template_cloudinit_config.elk_user_data.rendered}"
  }

  boot_disk {
    initialize_params {
      image = "pachamama-${var.env}-ubuntu-base"
    }
  }

  network_interface {
    subnetwork = "${var.subnet}"

    # Need an ephemeral IP so apt-get can install the elk packages
    access_config {
      # Ephemeral IP - leaving this block empty will generate a new external IP and assign it to the machine
    }
  }

#  service_account {
#    scopes = ["storage-rw"]
#  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "elk_user_data" {
  template = "${file("${path.module}/user_data.yml")}"

  vars {
    env = "${var.env}"
    install_es_sh = "${file("${path.module}/install_es.sh")}"
    docker_compose_yml = "${file("${path.module}/docker-compose.yml")}"
  }
}

# Render a multi-part cloudinit config making use of the part
# above, and other source files
data "template_cloudinit_config" "elk_user_data" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.elk_user_data.rendered}"
  }
}

resource "google_compute_instance" "gitlab" {
  name                  = "gitlab"
  project               = "${var.project}"
  description = "${var.name}-${var.env} Docker Registry Template"
  machine_type = "${var.instance_type}"
  tags = ["registry"]
  zone = "${element(var.zones, 0)}"

  metadata {
    #ssh-keys = "${var.user}:${file("${var.ssh_key}")}"
    user-data = "${data.template_cloudinit_config.gitlab_user_data.rendered}"
  }

  boot_disk {
    initialize_params {
      image = "pachamama-${var.env}-ubuntu-base"
    }
  }

  network_interface {
    subnetwork = "${var.subnet}"

    #omitting access_config block so that there is no external IP
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

data "template_file" "gitlab_user_data" {
  template = "${file("${path.module}/user_data.yml")}"

  vars {
    env = "${var.env}"
  }
}

# Render a multi-part cloudinit config making use of the part
# above, and other source files
data "template_cloudinit_config" "gitlab_user_data" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.gitlab_user_data.rendered}"
  }
}

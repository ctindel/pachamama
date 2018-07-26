resource "google_compute_instance_template" "docker_registry" {
  name_prefix  = "registry"
  project      = "${var.project}"
  instance_description = "${var.name}-${var.env} Docker Registry Template"
  machine_type = "${var.instance_type}"
  tags = ["registry"]

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  metadata {
    #ssh-keys = "${var.user}:${file("${var.ssh_key}")}"
    user-data = "${data.template_cloudinit_config.docker_registry_user_data.rendered}"
  }

  disk {
    source_image = "pachamama-${var.env}-ubuntu-base"
    auto_delete = true
    boot = true
  }

  network_interface {
    subnetwork = "${var.subnet}"

    #omitting access_config block so that there is no external IP
    access_config {
      # Ephemeral IP - leaving this block empty will generate a new external IP and assign it to the machine
    }
  }

  service_account {
    # storage-rw: We store docker images in the GCS bucket
    scopes = ["storage-rw"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group_manager" "docker_registry" {
    name = "registry"
    project = "${var.project}"
    instance_template = "${google_compute_instance_template.docker_registry.self_link}"
    base_instance_name = "registry"
    zone = "${element(var.zones, 0)}"
    target_size = "1"
}

data "template_file" "docker_registry_user_data" {
  template = "${file("${path.module}/user_data.yml")}"

  vars {
    env = "${var.env}"
  }
}

# Render a multi-part cloudinit config making use of the part
# above, and other source files
data "template_cloudinit_config" "docker_registry_user_data" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.docker_registry_user_data.rendered}"
  }
}

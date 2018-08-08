resource "google_container_cluster" "primary" {
  project            = "${var.project}"
  name               = "${var.name}"
  zone               = "${element(var.zones, 0)}"
  additional_zones   = "${slice(var.zones, 1, length(var.zones) - 1)}"
  initial_node_count = "${var.instance_count}"
  network            = "${var.network}"
  subnetwork         = "${var.subnet}"
  master_ipv4_cidr_block = "${var.master_ipv4_cidr_block}"
  private_cluster    = "${var.private_cluster}"

  master_auth {
    username = "username"
    password = "passwordpassword"
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  addons_config {
    http_load_balancing {
      disabled = true
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name = "${var.name}-pods"
    services_secondary_range_name = "${var.name}-services"
  }

  node_config {
    disk_size_gb = "32"
    image_type   = "ubuntu"
    machine_type = "${var.instance_type}"
    preemptible  = false

    labels {
      pool    = "default-pool"
      cluster = "the-cluster"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  lifecycle {
    create_before_destroy = true
  }

}

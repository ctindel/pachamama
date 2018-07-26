resource "random_id" "username" {
  byte_length = 12
}

resource "random_id" "password" {
  byte_length = 12
}

data "google_compute_zones" "available" {}

resource "google_container_cluster" "primary" {
  project            = "${var.project_id}"
  name               = "${var.name}"
  zone               = "${data.google_compute_zones.available.names[0]}"
  initial_node_count = "${var.node_count}"

  additional_zones = [
    "${data.google_compute_zones.available.names[1]}"
  ]

  master_auth {
    username = "${random_id.username.hex}"
    password = "${random_id.password.hex}"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

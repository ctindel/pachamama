resource "google_compute_subnetwork" "subnet" {
  name          = "${var.subnet_name}"
  project       = "${var.project}"
  region        = "${var.region}"
  network       = "${var.network}"
  ip_cidr_range = "${var.ip_range}"
  private_ip_google_access = true
  secondary_ip_range = {
    range_name = "${var.name}-pods"
    ip_cidr_range = "${var.pod_cidr_range}"
  }
  secondary_ip_range = {
    range_name = "${var.name}-services"
    ip_cidr_range = "${var.cluster_service_cidr_range}"
  }
}

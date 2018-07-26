
provider "kubernetes" {
  host = "https://${google_container_cluster.primary.endpoint}"
  username = "${google_container_cluster.primary.master_auth.0.username}"
  password = "${google_container_cluster.primary.master_auth.0.password}"
  client_certificate = "${base64decode(google_container_cluster.primary.master_auth.0.client_certificate)}"
  client_key = "${base64decode(google_container_cluster.primary.master_auth.0.client_key)}"
  cluster_ca_certificate = "${base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)}"
}

# resource "kubernetes_namespace" "n" {
#   metadata {
#     name = "blablah"
#   }
# }

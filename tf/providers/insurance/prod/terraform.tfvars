env = "prod"
name = "insurance"
region = "us-east1"
owner_group_email = "gcp-admins@tindelmg.com"
service_account_email = "198376435150-compute@developer.gserviceaccount.com"
#billing_account = "01F975-11BF2C-6BC84D"
#org = "BLAH"
zones = ["us-east1-b", "us-east1-c"] 
internal_subnet_ip_range = "192.168.1.0/24"
management_subnet_ip_range = "192.168.10.0/24"
bastion_instance_type = "f1-micro" 
docker_registry_instance_type = "n1-standard-4"
gitlab_instance_type = "n1-standard-4"
mongodb_instance_type = "n1-standard-4"
elasticsearch_instance_type = "n1-standard-4"
external_k8s_master_k8s_ip_range = "192.168.20.0/28"
external_k8s_cluster_service_cidr_range = "10.192.0.0/20"    # 10.192.0.0 - 10.192.15.255
external_k8s_node_cidr_range = "10.193.0.0/23"       # 10.193.0.0 - 10.193.1.255
external_k8s_pod_cidr_range = "10.194.0.0/15"        # 10.194.0.0 - 10.195.255.255
external_k8s_instance_type = "n1-standard-4"
external_k8s_instance_count = "3"
internal_k8s_master_k8s_ip_range = "192.168.30.0/28"
internal_k8s_cluster_service_cidr_range = "10.189.0.0/20"    # 10.192.0.0 - 10.192.15.255
internal_k8s_node_cidr_range = "10.190.0.0/23"       # 10.193.0.0 - 10.193.1.255
internal_k8s_pod_cidr_range = "10.190.2.0/24"        # 10.194.0.0 - 10.195.255.255
internal_k8s_instance_type = "n1-standard-4"
internal_k8s_instance_count = "3"
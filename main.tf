module "vpc" {
  source                 = "./vpc"
  vpc_project            = "mercurial-time-233114"
  vpc_name               = "vpc-network"
  vpc_auto_create_subnet = false
  vpc_mtu                = 1460
}

module "firewalls" {
  source                 = "./firewall"
  firewall_name          = "allow-ssh"
  firewall_network       = module.vpc.vpc_name
  firewall_priority      = 1000
  firewall_direction     = "INGRESS"
  firewall_project       = module.vpc.vpc_project
  firewall_source_ranges = ["0.0.0.0/0"]
  firewall_protocol      = "tcp"
  firewall_ports         = ["22"]
  depends_on = [
    module.vpc,
    module.restricted_subnet
  ]
  fire_network           = module.vpc.vpc_name
}



module "management_subnet" {
  source         = "./subnets"
  subnet_name    = "management-subnet"
  subnet_cider   = "10.0.1.0/24"
  subnet_region  = "asia-east1"
  subnet_network = module.vpc.vpc_id
  subnet_project = module.vpc.vpc_project
  depends_on = [
    module.vpc
  ]
}

module "restricted_subnet" {
  source         = "./subnets"
  subnet_name    = "restricted-subnet"
  subnet_cider   = "10.0.2.0/24"
  subnet_region  = "asia-east1"
  subnet_network = module.vpc.vpc_id
  subnet_project = module.vpc.vpc_project
  depends_on = [
    module.vpc
  ]
}

module "nat" {
  source         = "./nat-gateway"
  router_name    = "my-router"
  router_region  = module.management_subnet.subnet_region
  router_network = module.vpc.vpc_name

  nat_router_name            = "gateway-router"
  nat_router_subnetwork_name = module.management_subnet.subnet_name
}

module "private_vm" {
  source                  = "./vm"
  service_account_id      = "managment-cluster"
  service_account_project = module.vpc.vpc_project
  service_account_role    = "roles/container.admin"
  vm_name                 = "my-vm"
  vm_type                 = "f1-micro"
  vm_zone                 = "asia-east1-b"
  vm_project              = "mercurial-time-233114"
  vm_network              = "management-subnet"
  vm_image                = "ubuntu-os-cloud/ubuntu-2204-lts" #"custom-img-nginx"
  script                  = file("myscript.sh")
  depends_on = [
    module.management_subnet
  ]
}


module "kubernetes_cluster" {
  source                    = "./k8s_cluster"
  k8s_service_project       = module.vpc.vpc_project
  k8s_cluster_name          = "my-gke-cluster"
  k8s_cluster_location      = "asia-east1-a"
  k8s_cluster_network       = module.vpc.vpc_name
  k8s_cluster_subnetwork    = module.restricted_subnet.subnet_name
  k8s_cluster_count         = 1
  k8s_cluster_master_cider  = "172.16.0.0/28"
  k8s_cluster_cluster_cider = "192.168.0.0/16"
  k8s_cluster_service_cider = "10.96.0.0/16"
  k8s_cluster_node_name     = "my-node-pool"
  depends_on = [
    module.restricted_subnet
  ]
}

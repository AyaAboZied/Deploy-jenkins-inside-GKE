resource "google_compute_router" "router" {
  name    = var.router_name    #"route-a"
  region  = var.router_region  #"asia-east1"
  network = var.router_network #"vpc-network"
}

resource "google_compute_router_nat" "nat_router" {
  name                               = var.nat_router_name #"nat-router"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

}
resource "google_service_account" "kubernetes" {
  account_id   = "kubernetes"
  display_name = "Service Account"
}
resource "google_project_iam_member" "kubernetes_role" {
  project = var.k8s_service_project 
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.kubernetes.email}"
}
resource "google_project_iam_member" "gke_sa" {
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.kubernetes.email}"
  project = var.k8s_service_project 
}
resource "google_project_iam_member" "gke_storage_sa" {
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.kubernetes.email}"
  project = var.k8s_service_project 
}


resource "google_container_cluster" "gke" {
  name       = var.k8s_cluster_name       
  location   = var.k8s_cluster_location  
  network    = var.k8s_cluster_network    
  subnetwork = var.k8s_cluster_subnetwork 


  remove_default_node_pool = true
  initial_node_count       = var.k8s_cluster_count 

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = var.k8s_cluster_master_cider #"172.16.0.0/28"
  }


  ip_allocation_policy {

  }

  master_authorized_networks_config {
    cidr_blocks {
      display_name = "management-subnet"
      cidr_block   = "10.0.1.0/24"
    }
  }

}

resource "google_container_node_pool" "general" {
  name       = var.k8s_cluster_node_name
  location   = "asia-east1-a"
  cluster    = google_container_cluster.gke.name
  node_count = 1

  node_config {
    image_type = "COS_CONTAINERD"
    machine_type = "e2-standard-4"
    service_account = google_service_account.kubernetes.email
    preemptible = true
    oauth_scopes = [ 
        "https://www.googleapis.com/auth/cloud-platform"
      ]
  }
}
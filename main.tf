# Defines a private, regional GKE cluster
resource "google_container_cluster" "primary" {
  name     = "cka-private-gke"
  location = var.region

  # By specifying only two zones, we ensure a total of two nodes when
  # node_count is set to 1.
  node_locations = [
    "us-east1-b",
    "us-east1-c"
  ]

  remove_default_node_pool = true
  initial_node_count       = 1

  # This is a Standard cluster, not Autopilot
  enable_autopilot = false

  # Configuration for a private cluster
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_global_access_enabled = true
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "Allow Public Access"
    }
  }

  # Enable Workload Identity for secure access to GCP services
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

# Defines the private GKE node pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-nodes"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  
  # With node_count = 1 and only two specified node_locations,
  # the total number of nodes will be two (1 node x 2 zones).
  node_count = 1

  node_config {
    machine_type = "e2-medium"
    # A small disk size is sufficient for a dev/learning cluster.
    disk_size_gb = 20
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

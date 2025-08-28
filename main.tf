resource "google_container_cluster" "primary" {
  name     = "cka-gke"
  location = var.region

  # By specifying only two zones, we ensure a total of two nodes when
  # node_count is set to 1.
  node_locations = [
    "us-east1-b",
    "us-east1-c"
  ]

  remove_default_node_pool = true
  initial_node_count       = 1

  # Enable Workload Identity for secure access to GCP services
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

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

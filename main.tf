

resource "google_container_cluster" "primary" {
  name     = "cka-gke"
  location = var.region
 # A regional cluster with the control plane replicated across multiple zones.
  # We will manually specify the node locations for total node count control.
  node_locations = [
    "us-east1-b",
    "us-east1-c",
    "us-east1-d"
  ]

  remove_default_node_pool = true
  initial_node_count       = 1

  # Enable Workload Identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-nodes"
  location   = var.region
  cluster    = google_container_cluster.primary.name

  node_count = 1


  node_config {
        machine_type = "e2-medium"
    disk_size_gb = 20  # This would lower the total request to 480 GB
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "helm_release" "argocd_cd" {
  name        ="argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart =      "argo-cd" 
  namespace    ="argocd"
  version      = "5.34.5"
  create_namespace   = true 
  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.primary_nodes
]

  values = [
    yamlencode ({
      server = {
        service = {
          type="LoadBalancer"
        }
      }
    })
  ]
}


terraform {
  required_version = ">= 1.3.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_container_cluster" "primary" {
  name     = "cka-gke"
  location = var.region

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

  node_count = var.node_count

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
<<<<<<< HEAD
=======

resource "google_container_cluster" "primary" {
  name     = "cka-gke"
  location = var.region
  remove_default_node_pool = true
  initial_node_count       = 1

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-nodes"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 2

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

>>>>>>> df1731b (Add Terraform GKE setup)

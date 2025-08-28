terraform {
  required_version = ">= 1.5"

  backend "remote" {
    organization = "cka-stock"  # Your Terraform Cloud org

    workspaces {
      name = "cka-stock"         # Your workspace name in Terraform Cloud
    }
  }

reqired_providers {
  google = {
    source = "hashicorp/google"
    version = "~> 6.0"
  }
  kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.29"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
}

}

provider "google" {
  credentials = var.GOOGLE_CREDENTIALS
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}


data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = google_container_cluster.primary.endpoint
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth.0.cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host                   = google_container_cluster.primary.endpoint
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(
      google_container_cluster.primary.master_auth.0.cluster_ca_certificate
    )
  }
}


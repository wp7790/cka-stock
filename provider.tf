# Declares the required providers for Terraform to download and use.
terraform {
  required_version = ">= 1.5"

  backend "remote" {
    organization = "cka-stock"
    workspaces {
      name = "cka-stock"
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
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

# Configures the Google provider with your project credentials.
provider "google" {
  credentials = var.GOOGLE_CREDENTIALS
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

# Fetches a client token for authentication.
data "google_client_config" "default" {}

# Fetches the GKE cluster details after it is created.
data "google_container_cluster" "primary" {
  name     = google_container_cluster.primary.name
  location = var.region
}

# Configures the Kubernetes provider to connect to the GKE cluster.
provider "kubernetes" {
  host                   = "https://${google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

# Configures the Helm provider to use the Kubernetes provider's configuration.
provider "helm" {
  kubernetes {
    host                   = "https://${google_container_cluster.primary.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  }
}

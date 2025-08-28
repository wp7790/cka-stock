terraform {
  required_version = ">= 1.5"

  backend "remote" {
    organization = "cka-stock"  # Your Terraform Cloud org

    workspaces {
      name = "cka-stock"         # Your workspace name in Terraform Cloud
    }
  }



}

provider "google" {
  credentials = var.GOOGLE_CREDENTIALS
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}



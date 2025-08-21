terraform {
  backend "gcs" {
    bucket = "cka-tf-state-wp23"
    prefix = "gke-cluster"
  }
}

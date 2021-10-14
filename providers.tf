terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = var.gcp_project_name
  region  = var.gcp_region
}
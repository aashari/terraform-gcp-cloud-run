terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.24.0"
    }
  }
  required_version = ">= 1.11.1"
}

provider "google" {
  project = var.gcp_project_name
  region  = var.gcp_region
}
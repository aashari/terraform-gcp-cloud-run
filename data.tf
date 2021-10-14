data "archive_file" "init" {
  type        = "zip"
  source_dir  = var.docker_source_path
  output_path = "/tmp/${var.service_name}-image-${random_string.naming-hash.result}.zip"
}

data "google_container_registry_repository" "registry" {
  project = var.gcp_project_name
  region  = var.docker_region
}

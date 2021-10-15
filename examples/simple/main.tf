module "gcp-cloud-run" {
  source = "../../"

  service_name       = "ashxyz"
  gcp_project_name   = "ashari-tech-main"
  gcp_region         = "asia-southeast2"
  docker_source_path = "src"
  docker_region      = "asia"
}

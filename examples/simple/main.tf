module "gcp-cloud-run" {
  source = "../../"

  service_name     = "nginx-demo"
  gcp_project_name = "io-ashari"
  gcp_region       = "asia-southeast2"
  image_url        = "docker.io/nginx:latest"
  container_port   = 80 # Nginx uses port 80 by default

  # Scaling configuration
  min_instances = 0
  max_instances = 50

  # Disable health checks for now to simplify deployment
  startup_probe_enabled = false

  # Environment variables
  env_vars = {
    "NGINX_ENTRYPOINT_QUIET_LOGS" = "1"
  }

  # Service annotations
  service_annotations = {
    "run.googleapis.com/ingress" = "all"
  }
}

output "service-endpoint" {
  value       = module.gcp-cloud-run.service-endpoint
  description = "The URL of the deployed Nginx service"
}

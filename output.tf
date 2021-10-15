output "docker-image-url" {
  value       = local.docker_image_url
  description = "A generated docker image URL"
}

output "docker-image-tag" {
  value       = data.archive_file.init.output_sha
  description = "A generated docker image tag"
}

output "service-endpoint" {
  value       = google_cloud_run_service.run.status[0].url
  description = "A generated service URL"
}

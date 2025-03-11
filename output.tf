output "service-name" {
  value       = google_cloud_run_service.run.name
  description = "The name of the Cloud Run service"
}

output "service-endpoint" {
  value       = google_cloud_run_service.run.status[0].url
  description = "The URL of the deployed Cloud Run service"
}

output "service-account" {
  value       = google_service_account.run.email
  description = "The email of the service account used by the Cloud Run service"
}

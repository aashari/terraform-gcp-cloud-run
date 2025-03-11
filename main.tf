resource "google_service_account" "run" {
  account_id   = substr(var.service_name, 0, min(28, length(var.service_name)))
  display_name = "${var.service_name}-service-account"
}

resource "google_project_iam_member" "run-iam" {
  project = var.gcp_project_name
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.run.email}"
}

resource "google_cloud_run_service" "run" {
  name     = var.service_name
  location = var.gcp_region
  project  = var.gcp_project_name

  metadata {
    annotations = var.service_annotations
  }

  template {
    metadata {
      annotations = merge(
        {
          "autoscaling.knative.dev/minScale" = var.min_instances
          "autoscaling.knative.dev/maxScale" = var.max_instances
        },
        var.vpc_connector != null ? {
          "run.googleapis.com/vpc-access-connector" = var.vpc_connector
          "run.googleapis.com/vpc-access-egress"    = var.vpc_egress
        } : {},
        var.template_annotations
      )
    }

    spec {
      service_account_name  = google_service_account.run.email
      container_concurrency = var.container_concurrency
      timeout_seconds       = var.timeout_seconds

      containers {
        image = var.image_url

        resources {
          limits = {
            "cpu"    = var.container_cpu
            "memory" = var.container_memory
          }
        }

        dynamic "env" {
          for_each = var.env_vars
          content {
            name  = env.key
            value = env.value
          }
        }

        ports {
          name           = "http1"
          container_port = var.container_port
        }

        dynamic "startup_probe" {
          for_each = var.startup_probe_enabled ? [1] : []
          content {
            initial_delay_seconds = var.startup_probe_initial_delay_seconds
            timeout_seconds       = var.startup_probe_timeout_seconds
            period_seconds        = var.startup_probe_period_seconds
            failure_threshold     = var.startup_probe_failure_threshold

            http_get {
              path = var.startup_probe_type == "http_get" ? var.startup_probe_path : "/"
              port = var.container_port
            }
          }
        }

        dynamic "liveness_probe" {
          for_each = var.liveness_probe_enabled ? [1] : []
          content {
            initial_delay_seconds = var.liveness_probe_initial_delay_seconds
            timeout_seconds       = var.liveness_probe_timeout_seconds
            period_seconds        = var.liveness_probe_period_seconds
            failure_threshold     = var.liveness_probe_failure_threshold

            http_get {
              path = var.liveness_probe_type == "http_get" ? var.liveness_probe_path : "/"
              port = var.container_port
            }
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true

  lifecycle {
    ignore_changes = [
      metadata[0].annotations["client.knative.dev/user-image"],
      metadata[0].annotations["run.googleapis.com/client-name"],
      metadata[0].annotations["run.googleapis.com/client-version"],
      metadata[0].annotations["run.googleapis.com/operation-id"],
      template[0].metadata[0].annotations["client.knative.dev/user-image"],
      template[0].metadata[0].annotations["run.googleapis.com/client-name"],
      template[0].metadata[0].annotations["run.googleapis.com/client-version"],
    ]
  }
}

resource "google_cloud_run_service_iam_member" "member" {
  location = google_cloud_run_service.run.location
  service  = google_cloud_run_service.run.name
  role     = "roles/run.invoker"
  member   = var.private_service ? "serviceAccount:${google_service_account.run.email}" : "allUsers"
}

resource "google_cloud_run_domain_mapping" "domain_mapping" {
  count    = var.custom_domain != "" ? 1 : 0
  location = var.gcp_region
  name     = var.custom_domain

  metadata {
    namespace = var.gcp_project_name
  }

  spec {
    route_name = google_cloud_run_service.run.name
  }
}

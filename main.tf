resource "random_string" "naming-hash" {
  length  = 16
  special = false
  upper   = false
}

resource "docker_image" "docker-image" {
  name = local.docker_image_url
  build {
    path = var.docker_source_path
    tag  = ["${local.docker_image_url}:${data.archive_file.init.output_sha}"]
  }
}

resource "null_resource" "build-run" {

  depends_on = [
    docker_image.docker-image
  ]

  provisioner "local-exec" {
    command = "docker push ${local.docker_image_url}:${data.archive_file.init.output_sha}"
  }

  triggers = {
    image_url = "${local.docker_image_url}:${data.archive_file.init.output_sha}"
  }

}

resource "google_service_account" "run" {
  account_id   = substr(local.docker_image_name, 0, 28)
  display_name = "${local.docker_image_name}-service-account"
}

resource "google_project_iam_member" "run-iam" {
  role   = "roles/editor"
  member = "serviceAccount:${google_service_account.run.email}"
}

resource "google_cloud_run_service" "run" {

  depends_on = [
    null_resource.build-run
  ]

  name     = local.docker_image_name
  location = var.gcp_region

  template {
    spec {
      service_account_name  = google_service_account.run.email
      container_concurrency = var.container_concurrency
      containers {
        image = "${local.docker_image_url}:${data.archive_file.init.output_sha}"
        resources {
          limits = {
            "cpu"    = var.container_cpu
            "memory" = var.container_memory
          }
        }
        env {
          name  = "IMAGE_URL"
          value = "${local.docker_image_url}:${data.archive_file.init.output_sha}"
        }
        env {
          name  = "NODE_ENV"
          value = "production"
        }
        ports {
          name           = "http1"
          container_port = var.container_port
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "member" {
  location = google_cloud_run_service.run.location
  service  = google_cloud_run_service.run.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "null_resource" "image-removal" {

  count = var.remove_image_when_destroy == true ? 1 : 0

  triggers = {
    docker_image_url          = local.docker_image_url
    remove_image_when_destroy = var.remove_image_when_destroy
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      gcloud container images list-tags ${self.triggers.docker_image_url} --format=json \
        | grep "tags" -A1 \
        | tail -n 1 \
        | sed -e 's/^[ \t]*//' \
        | cut -d '"' -f 2 \
        | xargs -L1 -I'{}' gcloud container images delete ${self.triggers.docker_image_url}:{} --force-delete-tags
    EOT
  }

}

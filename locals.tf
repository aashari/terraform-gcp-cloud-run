locals {
  docker_image_name = "${var.service_name}-image-${random_string.naming-hash.result}"
  docker_image_url  = "${data.google_container_registry_repository.registry.repository_url}/${var.service_name}-image-${random_string.naming-hash.result}"
}

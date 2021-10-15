variable "service_name" {
  description = "The name of the service"
  type        = string
}

variable "gcp_project_name" {
  description = "The name of GCP project"
  type        = string
}

variable "gcp_region" {
  description = "The name of GCP region"
  type        = string
}

variable "remove_image_when_destroy" {
  description = "When you destroy the stacks, do you want to remove all of the images as well?"
  type        = bool
  default     = true
}

variable "docker_source_path" {
  description = "The path of the service/application source code"
  type        = string
}

variable "docker_region" {
  description = "The default region name, available value asia, us, eu"
  type        = string
  default     = ""
}

variable "container_concurrency" {
  description = "The maximum concurrent per container"
  type        = string
  default     = "30"
}

variable "container_port" {
  description = "The port to access the container"
  type        = string
  default     = "3000"
}

variable "container_cpu" {
  description = "The amount of CPU allocated for the container"
  type        = string
  default     = "2000m"
}

variable "container_memory" {
  description = "The amount of memory allocated for the container"
  type        = string
  default     = "4096Mi"
}

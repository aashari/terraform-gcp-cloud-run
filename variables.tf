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

variable "image_url" {
  description = "The URL of the container image to deploy (e.g., docker.io/nginx:latest)"
  type        = string
}

variable "container_concurrency" {
  description = "The maximum concurrent per container"
  type        = number
  default     = 30
}

variable "container_port" {
  description = "The port to access the container"
  type        = number
  default     = 3000
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

variable "env_vars" {
  description = "Map of environment variables for the container"
  type        = map(string)
  default = {
    "NODE_ENV" = "production"
  }
}

variable "private_service" {
  description = "Whether to make the Cloud Run service private (only accessible within the VPC)"
  type        = bool
  default     = false
}

variable "min_instances" {
  description = "Minimum number of instances to keep running"
  type        = number
  default     = 0
}

variable "max_instances" {
  description = "Maximum number of instances to scale to"
  type        = number
  default     = 100
}

variable "timeout_seconds" {
  description = "Maximum duration (in seconds) the instance is allowed for responding to a request"
  type        = number
  default     = 300
}

variable "vpc_connector" {
  description = "The VPC connector to use for this service (format: projects/PROJECT/locations/LOCATION/connectors/CONNECTOR)"
  type        = string
  default     = null
}

variable "vpc_egress" {
  description = "The egress settings for the VPC connector (all-traffic or private-ranges-only)"
  type        = string
  default     = "private-ranges-only"
  validation {
    condition     = var.vpc_egress == "all-traffic" || var.vpc_egress == "private-ranges-only"
    error_message = "VPC egress must be either 'all-traffic' or 'private-ranges-only'."
  }
}

variable "service_annotations" {
  description = "Annotations to apply to the Cloud Run service"
  type        = map(string)
  default     = {}
}

variable "template_annotations" {
  description = "Annotations to apply to the Cloud Run service template"
  type        = map(string)
  default     = {}
}

variable "custom_domain" {
  description = "Custom domain to map to the Cloud Run service (must be verified in the project)"
  type        = string
  default     = ""
}

# Startup probe configuration
variable "startup_probe_enabled" {
  description = "Whether to enable startup probe"
  type        = bool
  default     = false
}

variable "startup_probe_type" {
  description = "Type of startup probe (http_get or tcp_socket)"
  type        = string
  default     = "tcp_socket"
  validation {
    condition     = contains(["http_get", "tcp_socket"], var.startup_probe_type)
    error_message = "Startup probe type must be either 'http_get' or 'tcp_socket'."
  }
}

variable "startup_probe_path" {
  description = "Path for HTTP GET startup probe"
  type        = string
  default     = "/"
}

variable "startup_probe_initial_delay_seconds" {
  description = "Initial delay seconds for startup probe"
  type        = number
  default     = 0
}

variable "startup_probe_timeout_seconds" {
  description = "Timeout seconds for startup probe"
  type        = number
  default     = 1
}

variable "startup_probe_period_seconds" {
  description = "Period seconds for startup probe"
  type        = number
  default     = 3
}

variable "startup_probe_failure_threshold" {
  description = "Failure threshold for startup probe"
  type        = number
  default     = 1
}

# Liveness probe configuration
variable "liveness_probe_enabled" {
  description = "Whether to enable liveness probe"
  type        = bool
  default     = false
}

variable "liveness_probe_type" {
  description = "Type of liveness probe (http_get or tcp_socket)"
  type        = string
  default     = "http_get"
  validation {
    condition     = contains(["http_get", "tcp_socket"], var.liveness_probe_type)
    error_message = "Liveness probe type must be either 'http_get' or 'tcp_socket'."
  }
}

variable "liveness_probe_path" {
  description = "Path for HTTP GET liveness probe"
  type        = string
  default     = "/"
}

variable "liveness_probe_initial_delay_seconds" {
  description = "Initial delay seconds for liveness probe"
  type        = number
  default     = 0
}

variable "liveness_probe_timeout_seconds" {
  description = "Timeout seconds for liveness probe"
  type        = number
  default     = 1
}

variable "liveness_probe_period_seconds" {
  description = "Period seconds for liveness probe"
  type        = number
  default     = 3
}

variable "liveness_probe_failure_threshold" {
  description = "Failure threshold for liveness probe"
  type        = number
  default     = 3
}

# Terraform GCP Cloud Run Module

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Google Cloud](https://img.shields.io/badge/GoogleCloud-%234285F4.svg?style=for-the-badge&logo=google-cloud&logoColor=white)
![Version](https://img.shields.io/badge/version-1.1.1-blue.svg?style=for-the-badge)

A comprehensive Terraform module for deploying and managing Google Cloud Run services with advanced configuration options.

## Overview

This module simplifies the deployment of containerized applications to Google Cloud Run by providing a flexible, reusable Terraform configuration. It handles service account creation, IAM permissions, container configuration, scaling, health checks, VPC connectivity, and custom domain mapping.

## Features

- **Simplified Deployment**: Deploy containerized applications to Cloud Run with minimal configuration
- **IAM Integration**: Automatic service account creation and IAM role assignment
- **Scaling Controls**: Configure min/max instances for optimal performance and cost management
- **Health Checks**: Configure startup and liveness probes for reliable service operation
- **Networking Options**: Support for VPC connectivity and private services
- **Custom Domains**: Optional mapping of verified domains to your Cloud Run services

## Architecture

The module creates and manages the following resources:

- **Google Service Account**: Dedicated service account for the Cloud Run service
- **IAM Bindings**: Appropriate permissions for the service account
- **Cloud Run Service**: The main service running your container
- **Custom Domain Mapping**: (Optional) Maps a verified domain to your service

## Requirements

| Name      | Version            |
| --------- | ------------------ |
| terraform | >= 1.11.1          |
| google    | >= 6.24.0, < 7.0.0 |

## Usage

### Basic Usage

```hcl
module "cloud_run_service" {
  source  = "github.com/aashari/terraform-gcp-cloud-run?ref=v1.1.1"

  service_name     = "my-service"
  gcp_project_name = "my-gcp-project"
  gcp_region       = "us-central1"
  image_url        = "gcr.io/my-project/my-image:latest"
}
```

### Complete Example with All Features

```hcl
module "cloud_run_service" {
  source  = "github.com/aashari/terraform-gcp-cloud-run?ref=v1.1.1"

  # Basic configuration
  service_name     = "api-service"
  gcp_project_name = "my-gcp-project"
  gcp_region       = "us-central1"
  image_url        = "gcr.io/my-project/api-service:latest"
  container_port   = 8080

  # Scaling configuration
  min_instances = 1
  max_instances = 10

  # Resource allocation
  container_cpu    = "1000m"
  container_memory = "512Mi"
  container_concurrency = 50
  timeout_seconds = 60

  # VPC Connector for private networking
  vpc_connector = "projects/my-project/locations/us-central1/connectors/my-connector"
  vpc_egress    = "all-traffic"

  # Health checks
  startup_probe_enabled = true
  startup_probe_type    = "http_get"
  startup_probe_path    = "/health"
  startup_probe_initial_delay_seconds = 5

  liveness_probe_enabled = true
  liveness_probe_type    = "http_get"
  liveness_probe_path    = "/health"
  liveness_probe_period_seconds = 10

  # Custom domain mapping
  custom_domain = "api.example.com"

  # Environment variables
  env_vars = {
    "NODE_ENV" = "production"
    "LOG_LEVEL" = "info"
    "DATABASE_URL" = "postgres://user:pass@host:port/db"
  }

  # Additional annotations
  service_annotations = {
    "run.googleapis.com/ingress" = "all"
  }

  template_annotations = {
    "run.googleapis.com/cpu-throttling" = "false"
  }

  # Access control (public or private)
  private_service = false
}
```

### Nginx Example

```hcl
module "nginx_service" {
  source  = "github.com/aashari/terraform-gcp-cloud-run?ref=v1.1.1"

  service_name     = "nginx-demo"
  gcp_project_name = "my-gcp-project"
  gcp_region       = "us-central1"
  image_url        = "docker.io/nginx:latest"
  container_port   = 80  # Nginx uses port 80 by default

  env_vars = {
    "NGINX_ENTRYPOINT_QUIET_LOGS" = "1"
  }

  # Make the service publicly accessible
  service_annotations = {
    "run.googleapis.com/ingress" = "all"
  }
}

output "nginx_url" {
  value = module.nginx_service.service-endpoint
  description = "The URL of the deployed Nginx service"
}
```

## Inputs

| Name                  | Description                                                                       | Type          | Default                      | Required |
| --------------------- | --------------------------------------------------------------------------------- | ------------- | ---------------------------- | :------: |
| service_name          | The name of your service (must be unique within the project)                      | `string`      | n/a                          |   yes    |
| gcp_project_name      | The name of your GCP project                                                      | `string`      | n/a                          |   yes    |
| gcp_region            | The name of GCP region                                                            | `string`      | n/a                          |   yes    |
| image_url             | The URL of the container image to deploy (e.g., docker.io/nginx:latest)           | `string`      | n/a                          |   yes    |
| container_concurrency | The maximum concurrent requests per container                                     | `number`      | `30`                         |    no    |
| container_port        | The port the container listens on                                                 | `number`      | `3000`                       |    no    |
| container_cpu         | The amount of CPU allocated for the container                                     | `string`      | `"2000m"`                    |    no    |
| container_memory      | The amount of memory allocated for the container                                  | `string`      | `"4096Mi"`                   |    no    |
| env_vars              | Map of environment variables for the container                                    | `map(string)` | `{"NODE_ENV": "production"}` |    no    |
| private_service       | Whether to make the Cloud Run service private                                     | `bool`        | `false`                      |    no    |
| min_instances         | Minimum number of instances to keep running                                       | `number`      | `0`                          |    no    |
| max_instances         | Maximum number of instances to scale to                                           | `number`      | `100`                        |    no    |
| timeout_seconds       | Maximum duration (in seconds) the instance is allowed for responding to a request | `number`      | `300`                        |    no    |
| vpc_connector         | The VPC connector to use for this service                                         | `string`      | `null`                       |    no    |
| vpc_egress            | The egress settings for the VPC connector                                         | `string`      | `"private-ranges-only"`      |    no    |
| service_annotations   | Annotations to apply to the Cloud Run service                                     | `map(string)` | `{}`                         |    no    |
| template_annotations  | Annotations to apply to the Cloud Run service template                            | `map(string)` | `{}`                         |    no    |
| custom_domain         | Custom domain to map to the Cloud Run service (must be verified in the project)   | `string`      | `""`                         |    no    |

### Health Check Configuration

| Name                                 | Description                                     | Type     | Default        | Required |
| ------------------------------------ | ----------------------------------------------- | -------- | -------------- | :------: |
| startup_probe_enabled                | Whether to enable startup probe                 | `bool`   | `false`        |    no    |
| startup_probe_type                   | Type of startup probe (http_get or tcp_socket)  | `string` | `"tcp_socket"` |    no    |
| startup_probe_path                   | Path for HTTP GET startup probe                 | `string` | `"/"`          |    no    |
| startup_probe_initial_delay_seconds  | Initial delay seconds for startup probe         | `number` | `0`            |    no    |
| startup_probe_timeout_seconds        | Timeout seconds for startup probe               | `number` | `1`            |    no    |
| startup_probe_period_seconds         | Period seconds for startup probe                | `number` | `3`            |    no    |
| startup_probe_failure_threshold      | Failure threshold for startup probe             | `number` | `1`            |    no    |
| liveness_probe_enabled               | Whether to enable liveness probe                | `bool`   | `false`        |    no    |
| liveness_probe_type                  | Type of liveness probe (http_get or tcp_socket) | `string` | `"http_get"`   |    no    |
| liveness_probe_path                  | Path for HTTP GET liveness probe                | `string` | `"/"`          |    no    |
| liveness_probe_initial_delay_seconds | Initial delay seconds for liveness probe        | `number` | `0`            |    no    |
| liveness_probe_timeout_seconds       | Timeout seconds for liveness probe              | `number` | `1`            |    no    |
| liveness_probe_period_seconds        | Period seconds for liveness probe               | `number` | `3`            |    no    |
| liveness_probe_failure_threshold     | Failure threshold for liveness probe            | `number` | `3`            |    no    |

## Outputs

| Name             | Description                                                    |
| ---------------- | -------------------------------------------------------------- |
| service-name     | The name of the Cloud Run service                              |
| service-endpoint | The URL of the deployed Cloud Run service                      |
| service-account  | The email of the service account used by the Cloud Run service |

## License

This project is licensed under the MIT License - see the LICENSE file for details.

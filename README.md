# Terraform GCP Cloud Run

This is a Terraform module to provision GCP Cloud Run to serve your container application or service

## Resources 

This Terraform module will create below resources:

* Google Container Image
* Google Service Account for Cloud Run
* Google Cloud Run service

## Dependencies

* Terraform: ~> 1.0.0
* Terraform provider: hashicorp/archive v2.2.0
* Terraform provider: hashicorp/google v3.88.0
* Terraform provider: kreuzwerker/docker v2.15.0
* Terraform provider: hashicorp/null v3.1.0
* Terraform provider: hashicorp/random v3.1.0

## Input Variables
| Variable Name         | Data Type    | Is Required                       | Default Value | Description                                                                                              |
|-----------------------|--------------|-----------------------------------|---------------|----------------------------------------------------------------------------------------------------------|
| service_name          | string       | yes                               |               | The name of your service, e.g. `my-web`, `ashari`, `ashweb`, or `andi-web`                               |
| gcp_project_name      | string       | yes                               |               | The name of your GCP project                                                                             |
| gcp_region            | string       | yes                               |               | The name of GCP region                                                                                   |
| remove_image_when_destroy         | bool       | no           | true              | When you destroy the stacks, do you want to remove all of the images as well?                                   |
| docker_source_path    | string       | yes |               | The path of the service/application source code                                |
| docker_region    | string       | no |               | The default region name, available value `asia`, `us`, `eu`                                |
| container_concurrency  | string         | no                                | 30         | The maximum concurrent per container                                        |
| container_port          | string       | no  |  3000             | The port to access the container                                 |
| container_cpu           | string       | no  |   2000m            | The amount of CPU allocated for the container                |
| container_memory         | string       | no  |  4096Mi             | The amount of memory allocated for the container                                                                             |

## Output Variables

* **docker-image-url**: A generated docker image URL
* **docker-image-tag**: A generated docker image tag
* **service-endpoint**: A generated service URL

## Sample Usage

### Simple Implementation

```
module "gcp-cloud-run" {
  source = "git@github.com:aashari/terraform-gcp-cloud-run.git?ref=v1.0.0"

  service_name       = "ashxyz"
  gcp_project_name   = "ashari-tech-main"
  gcp_region         = "asia-southeast2"
  docker_source_path = "src"
  docker_region      = "asia"
}

```

## Contribute

Feel free to contribute, don't forget to raise an issue first then create a PR with referenced to that issue, thanks!

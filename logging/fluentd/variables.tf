variable "region" {
  default     = "us-east-1"
  description = "The region of your infrastructure. Defaults to us-east-1."
}

variable "fluentd_bucket_name" {
  description = "The name to use for your FluentD bucket."
}

variable "ecs_cluster" {
  description = "The name of the ECS cluster to use."
}

variable "ecs_role" {
  description = "The name of the IAM role to use."
}

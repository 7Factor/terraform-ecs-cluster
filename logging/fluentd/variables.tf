variable "region" {
  default     = "us-east-1"
  description = "The region of your infrastructure. Defaults to us-east-1."
}

variable "desired_capacity" {
  description = "The number of EC2 instances for the ECS cluster."
}

variable "ecs_cluster" {}

variable "ecs_role" {}

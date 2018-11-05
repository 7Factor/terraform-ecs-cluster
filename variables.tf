// networking config
variable "region" {
  default     = "us-east-1"
  description = "The region of your infrastructure. Defaults to us-east-1."
}

variable "vpc_id" {
  description = "The id of your vpc."
}

variable "utility_accessible_sg" {
  description = "Pass in the ID of your access security group here."
}

variable "asg_subnets" {
  type        = "list"
  description = "The list of subnet IDs the ASG will launch instances into. These should be private."
}

// auto scaling group config
variable "instance_type" {
  default     = "t2.micro"
  description = "The type of ec2 container instance the asg will create. Defaults to t2.micro."
}

variable "key_name" {
  description = "The name of your pem key that will be associated with the ec2 container instances."
}

variable "desired_capacity" {
  default     = 2
  description = "The target number of container instances for the asg."
}

variable "min_size" {
  default     = 2
  description = "The mininum number of container isntances the asg will maintain."
}

variable "max_size" {
  default     = 3
  description = "The maximum number of container instances the asg will maintain."
}

variable "health_check_grace_period" {
  default     = 300
  description = "Time in seconds after instance comes into service before checking health. Defaults to 300."
}

// tags
variable "env" {
  description = "Tags relevant resources with your env. You should set this to 'stage' or 'prod'."
}

variable "fluentd_docker_image" {}

// networking config
variable "vpc_id" {
  description = "The id of your vpc."
}

variable "ecs_cluster_name" {
  description = "The name of your ECS cluster."
}

variable "utility_accessible_sg" {
  description = "Pass in the ID of your access security group here."
}

variable "asg_subnets" {
  type        = "list"
  description = "The list of subnet IDs the ASG will launch instances into. These should be private."
}

variable "lb_ingress_cidr" {
  default     = "0.0.0.0/0"
  description = "CIDR to allow access to this load balancer. Allows white listing of IPs if you need that kind of thing, otherwise it just defaults to erebody."
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

variable "ecs_logging" {
  default     = "[\\\"json-file\\\",\\\"awslogs\\\"]"
  description = "Adding logging option to ECS that the Docker containers can use. It is possible to add fluentd as well"
}

variable "asg_user_data" {
  default     = ""
  description = "Adding an option to run arbitrary commands to ECS host startup for package installation."
}

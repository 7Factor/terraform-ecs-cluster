# networking config
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
  type        = list(string)
  description = "The list of subnet IDs the ASG will launch instances into. These should be private."
}

variable "lb_ingress_cidr" {
  default     = "0.0.0.0/0"
  description = "CIDR to allow access to this load balancer. Allows white listing of IPs if you need that kind of thing, otherwise it just defaults to erebody."
}

# auto scaling group config
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

# capacity provider config
variable "managed_termination_protection" {
  description = "Enables or disables container-aware termination of instances in the auto scaling group when scale-in happens. Valid values are ENABLED and DISABLED."
  default     = "DISABLED"
}

variable "managed_scaling_maximum_scaling_step_size" {
  description = "The maximum step adjustment size. A number between 1 and 10,000."
  default     = 1000
}

variable "managed_scaling_minimum_scaling_step_size" {
  description = "The minimum step adjustment size. A number between 1 and 10,000."
  default     = 1
}

variable "managed_scaling_status" {
  description = "Whether auto scaling is managed by ECS. Valid values are ENABLED and DISABLED."
  default     = "DISABLED"
}

variable "managed_scaling_target_capacity" {
  description = "The target utilization for the capacity provider. A number between 1 and 100."
  default     = 80
}

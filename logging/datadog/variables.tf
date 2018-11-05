// ecs task config
variable "dd_agent_api_key" {
  description = "Your datadog API key for the dd-agent"
}

// ecs service config
variable "ecs_cluster" {
  description = "The name of your ecs cluster."
}

variable "desired_task_count" {
  default     = 1
  description = "The desired number of tasks for the service to keep running. Defaults to one."
}

// tags
variable "env" {
  description = "Tags relevant resources with your env. You should set this to 'stage' or 'prod'."
}

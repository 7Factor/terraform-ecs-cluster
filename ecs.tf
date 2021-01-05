resource "aws_ecs_cluster" "the_cluster" {
  name               = var.ecs_cluster_name
  capacity_providers = aws_ecs_capacity_provider.primary[*].name
}

resource "aws_ecs_capacity_provider" "primary" {
  name = "${var.ecs_cluster_name}-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_asg.arn
    managed_termination_protection = var.managed_termination_protection

    managed_scaling {
      maximum_scaling_step_size = var.managed_scaling_maximum_scaling_step_size
      minimum_scaling_step_size = var.managed_scaling_minimum_scaling_step_size
      status                    = var.managed_scaling_status
      target_capacity           = var.managed_scaling_target_capacity
    }
  }
}

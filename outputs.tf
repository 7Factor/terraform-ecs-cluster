output "ecs_cluster_name" {
  value       = aws_ecs_cluster.the_cluster.name
  description = "Name of the cluster that was created."
}

output "ecs_instance_role_name" {
  value       = aws_iam_role.ecs_role.name
  description = "The ID for the role that grants ECS containers AWS permissions."
}

output "asg_id" {
  value       = aws_autoscaling_group.ecs_asg.id
  description = "The ID of the ASG that controls the cluster. Use this to add your own scaling policies ad-hoc."
}

output "asg_minimum_capacity" {
  value       = aws_autoscaling_group.ecs_asg.min_size
  description = "The minumum capacity of the ASG."
}

output "asg_maximum_capacity" {
  value       = aws_autoscaling_group.ecs_asg.max_size
  description = "The maximum capacity of the ASG."
}

output "ecs_lb_sg_id" {
  value       = aws_security_group.ecs_accessible_sg.id
  description = "The ID of the security group to attach to load balancers for health checks."
}

output "ecs_instance_sg_id" {
  value       = aws_security_group.ecs_boxes.id
  description = "the ID of the security group that's attached to all ECS instances."
}

output "ecs_asg_instances_cpu_high_id" {
  value = aws_cloudwatch_metric_alarm.ecs_asg_instances_cpu_high.id
  description = "ID of the cloudwatch alarm. Used mainly for testing."
}

output "ecs_asg_instances_cpu_low_id" {
  value = aws_cloudwatch_metric_alarm.ecs_asg_instances_cpu_low.id
  description = "ID of the cloudwatch alarm. Used mainly for testing."
}

output "ecs_asg_instances_memory_high_id" {
  value = aws_cloudwatch_metric_alarm.ecs_asg_instances_memory_high.id
  description = "ID of the cloudwatch alarm. Used mainly for testing."
}

output "ecs_asg_instances_memory_low_id" {
  value = aws_cloudwatch_metric_alarm.ecs_asg_instances_memory_low.id
  description = "ID of the cloudwatch alarm. Used mainly for testing."
}

output "autoscaling_up_policy" {
  value = aws_autoscaling_policy.scale_up.arn
  description = "The policy arn for scaling up the ASG."
}

output "autoscaling_down_policy" {
  value = aws_autoscaling_policy.scale_down.arn
  description = "The policy arn for scaling down ASG."
}

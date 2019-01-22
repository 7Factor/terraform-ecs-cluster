output "ecs_instance_role_id" {
  value       = "${aws_iam_role.ecs_role.id}"
  description = "The ID for the role that grants ECS containers AWS permissions."
}

output "asg" {
  value       = "${aws_autoscaling_group.ecs_asg.id}"
  description = "The ID of the ASG that controls the cluster. Use this to add your own scaling policies ad-hoc."
}

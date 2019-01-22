output "ecs_instance_role_id" {
  value       = "${aws_iam_role.ecs_role.id}"
  description = "The ID for the role that grants ECS containers AWS permissions."
}

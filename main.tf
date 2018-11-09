# Comment this out if you're not using fluentd
module "fluentd" {
  source = "./logging/fluentd"

  desired_capacity = "${var.desired_capacity}"
  ecs_cluster      = "${aws_ecs_cluster.base_cluster.name}"
  ecs_role         = "${aws_iam_role.ecs_for_ec2_role.id}"
}

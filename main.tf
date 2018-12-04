# Comment this out if you're not using fluentd
module "fluentd" {
  source = "./logging/fluentd"

  fluentd_bucket_name = "${var.fluentd_bucket_name}"
  ecs_cluster = "${aws_ecs_cluster.base_cluster.name}"
  ecs_role    = "${aws_iam_role.ecs_for_ec2_role.id}"
}

# Comment this out if you're not using datadog
module "datadog" {
  source = "./logging/datadog"

  dd_agent_api_key = "${var.dd_agent_api_key}"
  ecs_cluster      = "${aws_ecs_cluster.base_cluster.name}"
  env              = "${var.env}"
}

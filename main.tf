# Comment this out if you're not using fluentd
module "fluentd" {
  source = "./logging/fluentd"

  desired_capacity     = "${var.desired_capacity}"
  ecs_cluster          = "${aws_ecs_cluster.base_cluster.name}"
  fluentd_docker_image = "${var.fluentd_docker_image}"
}

# Comment this out if you're not using datadog
module "datadog" {
  source = "./logging/datadog"

  // ecs task config
  dd_agent_api_key = "${var.dd_agent_api_key}"

  // ecs service config
  ecs_cluster        = "${aws_ecs_cluster.base_cluster.name}"
  // spin up exactly one dd-agent container per asg instance
  desired_task_count = "${aws_autoscaling_group.ecs_asg.desired_capacity}"

  // tags
  env = "${var.env}"
}

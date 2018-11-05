data "template_file" "container_definitions" {
  template = "${file("${path.root}/logging/datadog/containerDefinitions.json")}"

  vars {
    dd_agent_api_key = "${var.dd_agent_api_key}"
  }
}

resource "aws_ecs_task_definition" "datadog_task" {
  family                = "datadog-agent-task-${var.env}"
  container_definitions = "${data.template_file.container_definitions.rendered}"

  volume {
    name      = "docker_sock"
    host_path = "/var/run/docker.sock"
  }

  volume {
    name      = "proc"
    host_path = "/proc/"
  }

  volume {
    name      = "cgroup"
    host_path = "/cgroup/"
  }
}

resource "aws_ecs_service" "datadog_service" {
  name                = "datadog-service"
  task_definition     = "${aws_ecs_task_definition.datadog_task.arn}"
  desired_count       = "${var.desired_task_count}"
  launch_type         = "EC2"
  scheduling_strategy = "DAEMON"
  cluster             = "${var.ecs_cluster}"

  placement_constraints {
    type = "distinctInstance"
  }
}

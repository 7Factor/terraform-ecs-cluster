resource "aws_ecs_task_definition" "fluentd_task" {
  family                   = "fluentd-task"
  container_definitions = <<DEFINITION
[
  {
    "name": "fluentd-container",
    "image": "${var.fluentd_docker_image}",
    "cpu": 10,
    "memory": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 24224,
        "hostPort": 24224
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "fluentd_service" {
  name = "fluentd-service"
  task_definition = "${aws_ecs_task_definition.fluentd_task.arn}"
  cluster = "${var.ecs_cluster}"
  desired_count = "${var.desired_capacity}"
  launch_type = "EC2"
  placement_constraints = {
    type = "distinctInstance"
  }
}

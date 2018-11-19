resource "aws_ecr_repository" "fluentd" {
  name = "fluentd"
}

resource "aws_s3_bucket" "ecs_fluentd_logs_bucket" {
  bucket = "cc2dev-ecs-fluentd-logs"
  acl    = "private"

  tags {
    name = "ECS Fluentd Logs"
  }
}

data "aws_iam_policy_document" "ecs_task_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "fluentd_container_role" {
  name               = "fluentdContainerRole"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_task_role.json}"
}

data "aws_iam_policy_document" "s3_logging_policy" {
  statement {
    effect    = "Allow"
    resources = ["arn:aws:s3:::${aws_s3_bucket.ecs_fluentd_logs_bucket.bucket}"]

    actions = [
      "s3:ListBucket",
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["arn:aws:s3:::${aws_s3_bucket.ecs_fluentd_logs_bucket.bucket}/*"]

    actions = [
      "s3:PutObject",
    ]
  }
}

resource "aws_iam_role_policy" "ecs_access_to_fluentd_bucket_policy" {
  name = "FluentdS3BucketAccessPolicy"
  role = "${aws_iam_role.fluentd_container_role.id}"

  policy = "${data.aws_iam_policy_document.s3_logging_policy.json}"
}

resource "aws_ecs_task_definition" "fluentd_task" {
  family        = "fluentd-task"
  task_role_arn = "${aws_iam_role.fluentd_container_role.arn}"

  container_definitions = <<DEFINITION
[
  {
    "name": "fluentd-container",
    "image": "${aws_ecr_repository.fluentd.repository_url}",
    "cpu": 10,
    "memory": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 24224,
        "hostPort": 24224
      }
    ],
    "environment": [
      {
        "name": "S3_BUCKET",
        "value": "${aws_s3_bucket.ecs_fluentd_logs_bucket.bucket}"
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "fluentd_service" {
  name            = "fluentd-service"
  task_definition = "${aws_ecs_task_definition.fluentd_task.arn}"
  cluster         = "${var.ecs_cluster}"
  launch_type     = "EC2"
  scheduling_strategy = "DAEMON"
}

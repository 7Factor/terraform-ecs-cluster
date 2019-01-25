resource "aws_iam_instance_profile" "ecs_profile" {
  name = "${var.ecs_cluster_name}-profile"
  role = "${aws_iam_role.ecs_role.name}"
}

resource "aws_iam_role" "ecs_role" {
  name = "RoleForECSCluster-${var.ecs_cluster_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# We don't do a data lookup here because the data element requires an ARN,
# which would just be redundant and dumb.
resource "aws_iam_role_policy_attachment" "ecs_role_policy_attachment" {
  role       = "${aws_iam_role.ecs_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

data "aws_iam_role" "ecs_service_role" {
  name = "AWSServiceRoleForECS"
}

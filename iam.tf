resource "aws_iam_instance_profile" "ecs_for_ec2_profile" {
  name = "ecsForEc2Profile"
  role = "${aws_iam_role.ecs_for_ec2_role.name}"
}

resource "aws_iam_role" "ecs_for_ec2_role" {
  name = "ecsInstanceRole"

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

resource "aws_iam_role_policy_attachment" "ecs_for_ec2_role_policy_attachment" {
  role       = "${aws_iam_role.ecs_for_ec2_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

data "aws_iam_role" "ecs_service_role" {
  name = "AWSServiceRoleForECS"
}

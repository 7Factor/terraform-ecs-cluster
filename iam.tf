resource "aws_iam_instance_profile" "ecs_profile" {
  name = "${var.ecs_cluster_name}-profile"
  role = aws_iam_role.ecs_role.name
}

resource "aws_iam_role" "ecs_role" {
  name = "RoleForECSCluster-${var.ecs_cluster_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
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
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# gives ecs container instances the ability to create cloudwatch assets as needed
resource "aws_iam_policy" "cloudwatch_access_policy" {
  name = "${var.ecs_cluster_name}-cloudwatch-access-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cloudwatch_access_policy_attachment" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = aws_iam_policy.cloudwatch_access_policy.arn
}

# for sending raw emails with the AWS CLI from an EC2 instance
resource "aws_iam_role_policy_attachment" "ses_full_access_attachment" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}

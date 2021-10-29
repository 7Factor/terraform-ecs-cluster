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

data "aws_iam_policy" "aws_ssm_default" {
  name = "AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "aws_ecs_default" {
  name = "AmazonEC2ContainerServiceforEC2Role"
}

# We don't do a data lookup here because the data element requires an ARN,
# which would just be redundant and dumb.
resource "aws_iam_role_policy_attachment" "ecs_role_policy_attachment" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = data.aws_iam_policy.aws_ecs_default.arn
}

# Add SSM for patching
resource "aws_iam_role_policy_attachment" "add_ssm_for_patching" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = data.aws_iam_policy.aws_ssm_default.arn
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

terraform {
  required_version = ">=0.12.2"
}

data "aws_ami" "aws_linux_ecs" {
  most_recent = true

  owners = [591542846629]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

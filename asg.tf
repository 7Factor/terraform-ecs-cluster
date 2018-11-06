data "aws_ami" "aws_linux_ecs" {
  most_recent = true

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

resource "aws_launch_configuration" "ecs_container_instance" {
  name                 = "ecs-launch-configuration"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  image_id             = "${data.aws_ami.aws_linux_ecs.id}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs_for_ec2_profile.id}"

  security_groups = [
    "${aws_security_group.ecs_boxes.id}",
    "${var.utility_accessible_sg}"
  ]

  user_data = <<EOF
#!/bin/bash
sudo /bin/su -c 'echo ECS_CLUSTER=${aws_ecs_cluster.base_cluster.name} >> /etc/ecs/ecs.config'
sudo /bin/su -c 'echo ECS_AVAILABLE_LOGGING_DRIVERS="${var.ecs_logging}" >> /etc/ecs/ecs.config'
EOF
}

resource "aws_autoscaling_group" "ecs_asg" {
  name = "${var.env}-ecs-asg"

  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "EC2"
  desired_capacity          = "${var.desired_capacity}"
  min_size                  = "${var.min_size}"
  max_size                  = "${var.max_size}"
  vpc_zone_identifier       = ["${var.asg_subnets}"]
  launch_configuration      = "${aws_launch_configuration.ecs_container_instance.name}"

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "ECSInstance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Cluster"
    value               = "BaseECSInstances"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.env}"
    propagate_at_launch = true
  }
}

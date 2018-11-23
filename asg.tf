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

resource "aws_launch_template" "ecs_container_template" {
  name          = "${var.env}-ecs-asg"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"
  image_id      = "${data.aws_ami.aws_linux_ecs.id}"

  vpc_security_group_ids = [
    "${aws_security_group.ecs_boxes.id}",
    "${var.utility_accessible_sg}",
  ]

  user_data = <<EOF
#!/bin/bash
sudo /bin/su -c 'echo ECS_CLUSTER=${aws_ecs_cluster.base_cluster.name} >> /etc/ecs/ecs.config'
sudo /bin/su -c 'echo ECS_AVAILABLE_LOGGING_DRIVERS="${var.ecs_logging}" >> /etc/ecs/ecs.config'
EOF

  iam_instance_profile {
    name = "${aws_iam_instance_profile.ecs_for_ec2_profile.id}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  name = "${var.env}-ecs-asg-tmpl${aws_launch_template.ecs_container_template.latest_version}"

  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "EC2"
  desired_capacity          = "${var.desired_capacity}"
  min_size                  = "${var.min_size}"
  max_size                  = "${var.max_size}"
  vpc_zone_identifier       = ["${var.asg_subnets}"]

  launch_template = {
    id      = "${aws_launch_template.ecs_container_template.id}"
    version = "$$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "ECS Instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Cluster"
    value               = "Base ECS Instances"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.env}"
    propagate_at_launch = true
  }
}

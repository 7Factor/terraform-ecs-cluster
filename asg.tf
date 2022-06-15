resource "aws_launch_template" "ecs_container_template" {
  name          = "${replace(lower(var.ecs_cluster_name), " ", "-")}-asg"
  instance_type = var.instance_type
  key_name      = var.key_name
  image_id      = data.aws_ami.aws_linux_ecs.id

  vpc_security_group_ids = compact([
    aws_security_group.ecs_boxes.id,
    var.utility_accessible_sg,
  ])

  user_data = base64encode(templatefile("${path.module}/ecs_cluster.tftpl", {
    cluster_name  = var.ecs_cluster_name
    logging       = var.ecs_logging
    asg_user_data = var.asg_user_data
  }))

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      encrypted   = true
      volume_size = var.instance_ebs_volume_size
      volume_type = var.instance_ebs_volume_type
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_profile.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  tags = concat(
    var.additional_asg_tags,
    [
      {
        key                 = "Name"
        value               = "${var.ecs_cluster_name}${var.ecs_cluster_name_suffix}"
        propagate_at_launch = true
      },
      {
        key                 = "Cluster"
        value               = var.ecs_cluster_name
        propagate_at_launch = true
      },
      {
        key                 = "Patch Group"
        value               = local.ecs_patch_group_name
        propagate_at_launch = true
      },
      {
        key                 = "AmazonECSManaged"
        value               = "ignored"
        propagate_at_launch = true
      }
  ])
}

resource "aws_autoscaling_group" "ecs_asg" {
  name = "${replace(lower(var.ecs_cluster_name), " ", "-")}-asg-tmpl-${aws_launch_template.ecs_container_template.latest_version}"

  health_check_grace_period = var.health_check_grace_period
  health_check_type         = "EC2"
  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  max_size                  = var.max_size

  # flatten helps the terraform parser understand that this is a list of strings
  # (even though the type is explicity declared... thanks hashicorp)
  vpc_zone_identifier = flatten([var.asg_subnets])

  launch_template {
    id      = aws_launch_template.ecs_container_template.id
    version = "$Latest"
  }

  depends_on = [aws_launch_template.ecs_container_template]

  lifecycle {
    ignore_changes        = [desired_capacity]
    create_before_destroy = true
  }

  dynamic "tag" {
    for_each = local.tags
    content {
      key                 = tag.value["key"]
      value               = tag.value["value"]
      propagate_at_launch = tag.value["propagate_at_launch"]
    }
  }
}

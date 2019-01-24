# A CloudWatch alarm that monitors CPU utilization of cluster instances for scaling up
resource "aws_cloudwatch_metric_alarm" "ecs_asg_instances_cpu_high" {
  alarm_name          = "ecs-${var.env}-instances-CPU-Utilization-Above-80"
  alarm_description   = "This alarm monitors ECS ${var.env} instances' CPU utilization for scaling up."
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUReservation"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_actions       = ["${aws_autoscaling_policy.scale_up.arn}"]

  dimensions {
    ClusterName = "${aws_ecs_cluster.the_cluster.name}"
  }
}

# A CloudWatch alarm that monitors CPU utilization of cluster instances for scaling down
resource "aws_cloudwatch_metric_alarm" "ecs_asg_instances_cpu_low" {
  alarm_name          = "ecs-${var.env}-instances-CPU-Utilization-Below-5"
  alarm_description   = "This alarm monitors ECS ${var.env} instances' CPU utilization for scaling down."
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUReservation"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "5"
  alarm_actions       = ["${aws_autoscaling_policy.scale_down.arn}"]

  dimensions {
    ClusterName = "${aws_ecs_cluster.the_cluster.name}"
  }
}

# A CloudWatch alarm that monitors memory utilization of cluster instances for scaling up
resource "aws_cloudwatch_metric_alarm" "ecs_asg_instances_memory_high" {
  alarm_name          = "ecs-${var.env}-instances-Memory-Utilization-Above-80"
  alarm_description   = "This alarm monitors ECS ${var.env} instances' memory utilization for scaling up."
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryReservation"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_actions       = ["${aws_autoscaling_policy.scale_down.arn}"]

  dimensions {
    ClusterName = "${aws_ecs_cluster.the_cluster.name}"
  }
}

# A CloudWatch alarm that monitors memory utilization of cluster instances for scaling down
resource "aws_cloudwatch_metric_alarm" "ecs_asg_instances_memory_low" {
  alarm_name          = "ecs-${var.env}-instances-Memory-Utilization-Below-5"
  alarm_description   = "This alarm monitors ECS ${var.env} instances' memory utilization for scaling down."
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryReservation"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "5"
  alarm_actions       = ["${aws_autoscaling_policy.scale_down.arn}"]

  dimensions {
    ClusterName = "${aws_ecs_cluster.the_cluster.name}"
  }
}

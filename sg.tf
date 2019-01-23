resource "aws_security_group" "ecs_web_lb" {
  name        = "ecs-lb-sg"
  description = "Opens up web ALB on ports 80 and 443."
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["${var.lb_ingress_cidr}"]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["${var.lb_ingress_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Allow Load Balancer ECS Access"
  }
}

resource "aws_security_group" "ecs_boxes" {
  name        = "ecs-tasks-sg"
  description = "Allow inbound access from a set of ALBs based on an assigned security group."
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "ECS Cluster Instances"
  }
}

resource "aws_security_group_rule" "allow_lb_access_rule" {
    from_port       = 0
  type = "ingress"
    to_port         = 0
    protocol        = "-1"
    security_group_id = "${aws_security_group.ecs_boxes}"
    security_groups = ["${aws_security_group.ecs_web_lb.id}"]

  depends_on = ["aws_security_group.ecs_boxes", "aws_security_group.ecs_web_lb"]
}
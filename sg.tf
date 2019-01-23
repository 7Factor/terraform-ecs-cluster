resource "aws_security_group" "ecs_web_lb" {
  name        = "ecs-lb-sg-${var.region}"
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
    Name    = "ECS Web ALB"
    Cluster = "ECSCluster"
  }
}

resource "aws_security_group" "ecs_boxes" {
  name        = "ecs-tasks-sg-${var.region}"
  description = "Allow inbound access from the Web ALB only."
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.ecs_web_lb.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name    = "ECS Boxes"
    Cluster = "ECSCluster"
  }
}

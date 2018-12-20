resource "aws_ecs_cluster" "base_cluster" {
  name = "${var.ecs_cluster_name}"
}

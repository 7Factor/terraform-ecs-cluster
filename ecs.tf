resource "aws_ecs_cluster" "the_cluster" {
  name = var.ecs_cluster_name
}

# Deprecated

This version of the module has been deprecated in favor of https://github.com/7Factor/terraform-aws-ecs-cluster which
exists on the Terraform Registry. Please migrate to this version at your earliest convenience. Instructions for
migration can be found in the new repository.

# ECS Cluster via Terraform

This module will allow you to deploy an ECS Cluster composed of raw EC2 instances that are managed by an Auto Scaling Group.
From here you can bring in your own modules to deploy ECS Services and task definitions, or you can use 
[ours.](https://github.com/7Factor/terraform-ecs-http-task) Though you can run this on its own, we recommend running it together
with all of the modules you need for your CI/CD solution as part of a complete assembly line style process.

## Prerequisites

First, you need a decent understanding of how to use Terraform. [Hit the docs](https://www.terraform.io/intro/index.html) for that.
Then, you should familiarize yourself with ECS [concepts](https://aws.amazon.com/ecs/getting-started/), especially if you've 
never worked with a clustering solution before. Once you're good, import this module and 
pass the appropriate variables. Then, plan your run and deploy.

## Example Usage

**NOTE**
If you wish to hook in logging middleware such as [fluentd](https://www.fluentd.org/), you must pass the necessary params
to `ecs_logging`. Check out our [fluentd module](https://github.com/7Factor/terraform-ecs-fluentd) to see how we terraform
fluentd and for more information on how all the pipes connect together.

```hcl-terraform
module "ecs_cluster" {
  source = "git@github.com:7Factor/terraform-ecs-cluster.git"

  vpc_id                = "${var.vpc_id}"
  utility_accessible_sg = "${var.utility_accessible_sg}"
  asg_subnets           = "${var.web_private_subnets}"
  key_name              = "${var.ecs_key_name}"
  instance_type         = "t2.medium"
  ecs_logging           = "[\\\"json-file\\\",\\\"awslogs\\\",\\\"fluentd\\\"]"
  desired_capacity      = 2
  min_size              = 2
  max_size              = 4
}
```

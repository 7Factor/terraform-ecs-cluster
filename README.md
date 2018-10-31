# Base ECS Cluster

## This repo contains terraform that creates a base esc cluster managed by an asg.

### Variable Reference

* region - The region of your infrastructure. Defaults to us-east-1.
* utility_accessible_sg - Pass in the ID of your access security group here.
* asg_subnets - The list of subnet IDs the ASG will launch instances into. These should be private.
* instance_type - The type of ec2 container instance the asg will create. Defaults to t2.micro.
* key_name - The name of your pem key that will be associated with the ec2 container instances.
* desired_capacity - The target number of container instances for the asg.
* min_size - The minimum number of container instances the asg will maintain.
* max_size - The maximum number of container instances the asg will maintain.
* health_check_grace_period - Time in seconds after instance comes into service before checking health. Defaults to 300.
* env - Tags relevant resources with your env. You should set this to 'stage' or 'prod'.

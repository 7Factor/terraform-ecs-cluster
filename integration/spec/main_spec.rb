require 'awspec'
require 'hcl/checker'

TFVARS = HCL::Checker.parse(File.open('testing.tfvars').read())
TFOUTPUTS = eval(ENV['KITCHEN_KITCHEN_TERRAFORM_OUTPUTS'])


describe ecs_cluster(TFVARS['ecs_cluster_name']) do
  it { should exist }
  it { should be_active }
  its(:registered_container_instances_count) { should eq 1}
end

describe autoscaling_group(TFOUTPUTS[:asg_id][:value]) do
  it { should exist }
  its(:min_size) { should eq TFVARS['min_size']}
  its(:desired_capacity) { should eq TFVARS['desired_capacity']}
  its(:max_size) { should eq TFVARS['max_size']}
  its(:vpc_zone_identifier) { should include TFVARS['asg_subnets'][0]}
  its(:vpc_zone_identifier) { should include TFVARS['asg_subnets'][1]}
end
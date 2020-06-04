require 'awspec'
require 'hcl/checker'

TFVARS = HCL::Checker.parse(File.open('testing.tfvars').read())
TFOUTPUTS = eval(ENV['KITCHEN_KITCHEN_TERRAFORM_OUTPUTS'])

describe security_group(TFOUTPUTS[:ecs_lb_sg_id][:value]) do
  it { should exist }
  it { should have_tag('Name').value('Allow Load Balancer ECS Access') }
  its(:inbound) { should be_opened(443).protocol('tcp').for(TFVARS['lb_ingress_cidr']) }
  its(:inbound) { should be_opened(80).protocol('tcp').for(TFVARS['lb_ingress_cidr']) }
  its(:outbound) { should be_opened }
  its(:vpc_id) { should eq TFVARS['vpc_id']}
end

describe security_group(TFOUTPUTS[:ecs_instance_sg_id][:value]) do
  it { should exist }
  it { should have_tag('Name').value('ECS Cluster Instances') }
  its(:inbound) { should be_opened(0).protocol(-1).for(TFOUTPUTS[:ecs_lb_sg_id][:value]) }
  its(:outbound) { should be_opened }
  its(:vpc_id) { should eq TFVARS['vpc_id']}
end
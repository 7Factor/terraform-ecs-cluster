require 'awspec'
require 'hcl/checker'

TFVARS = HCL::Checker.parse(File.open('testing.tfvars').read())
TFOUTPUTS = eval(ENV['KITCHEN_KITCHEN_TERRAFORM_OUTPUTS'])


describe iam_role(TFOUTPUTS[:ecs_instance_role_name][:value]) do
  it { should exist }
  it { should have_iam_policy("#{TFVARS['ecs_cluster_name']}-cloudwatch-access-policy") }
  it { should have_iam_policy("arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role") }
end

describe iam_policy("#{TFVARS['ecs_cluster_name']}-cloudwatch-access-policy") do
  it { should exist }
  it { should be_attachable }
  it { should be_attached_to_role(TFOUTPUTS[:ecs_instance_role_name][:value]) }
end

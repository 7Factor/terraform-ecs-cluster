require 'awspec'
require 'hcl/checker'

TFVARS = HCL::Checker.parse(File.open('testing.tfvars').read())
TFOUTPUTS = eval(ENV['KITCHEN_KITCHEN_TERRAFORM_OUTPUTS'])

def test_alarm
  it { should exist }
  its(:comparison_operator) { should eq comparison_operator}
  its(:evaluation_periods) { should eq 1}
  its(:metric_name) { should eq metric_name}
  its(:namespace) { should eq 'AWS/ECS'}
  its(:period) { should eq period}
  its(:statistic) { should eq 'Average'}
  its(:threshold) { should eq threshold}
  its(:alarm_actions) { include alarm_actions}
end

describe 'this module' do
  context cloudwatch_alarm(TFOUTPUTS[:ecs_asg_instances_cpu_high_id][:value]) do
    let(:comparison_operator) { 'GreaterThanOrEqualToThreshold' }
    let(:metric_name) { 'CPUReservation' }
    let(:period) { 300 }
    let(:threshold) { 80 }
    let(:alarm_actions) { TFOUTPUTS[:autoscaling_up_policy][:value] }
    test_alarm
  end

  context cloudwatch_alarm(TFOUTPUTS[:ecs_asg_instances_cpu_low_id][:value]) do
    let(:comparison_operator) { 'LessThanThreshold' }
    let(:metric_name) { 'CPUReservation' }
    let(:period) { 300 }
    let(:threshold) { 5.0 }
    let(:alarm_actions) { TFOUTPUTS[:autoscaling_down_policy][:value] }
    test_alarm
  end

  context cloudwatch_alarm(TFOUTPUTS[:ecs_asg_instances_memory_high_id][:value]) do
    let(:comparison_operator) { 'GreaterThanOrEqualToThreshold' }
    let(:metric_name) { 'MemoryReservation' }
    let(:period) { 300 }
    let(:threshold) { 80 }
    let(:alarm_actions) { TFOUTPUTS[:autoscaling_down_policy][:value] }
    test_alarm
  end

  context cloudwatch_alarm(TFOUTPUTS[:ecs_asg_instances_memory_low_id][:value]) do
    let(:comparison_operator) { 'LessThanThreshold' }
    let(:metric_name) { 'MemoryReservation' }
    let(:period) { 300 }
    let(:threshold) { 5.0 }
    let(:alarm_actions) { TFOUTPUTS[:autoscaling_down_policy][:value] }
    test_alarm
  end
end
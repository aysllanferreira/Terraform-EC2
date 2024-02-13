terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.aws_region
}

resource "aws_launch_template" "template_machine" {
  image_id      = "ami-0c7217cdde317cfec"
  instance_type = var.instance
  key_name = var.sshKeys
  tags = {
    Name = var.instance_name
  }
  security_group_names = [ var.security_group_name ]
  user_data = var.production ? filebase64("ansible.sh") : "" 
}

resource "aws_key_pair" "sshKey" {
  key_name   = var.sshKeys
  public_key = file("${var.sshKeys}.pub")
}

resource "aws_autoscaling_group" "scaling_group" {
  availability_zones = [ "${var.aws_region}a", "${var.aws_region}b" ]
  name = var.group_name
  max_size = var.max_size
  min_size = var.min_size
  target_group_arns = var.production ? [ aws_lb_target_group.lbTarget[0].arn ] : []
  launch_template {
    id = aws_launch_template.template_machine.id
    version = "$Latest" 
  }
}

resource "aws_default_subnet" "subnet_1" {
  availability_zone = "${var.aws_region}a" 
}

resource "aws_default_subnet" "subnet_2" {
  availability_zone = "${var.aws_region}b" 
}

resource "aws_lb" "loadBalancer" {
  internal = false
  subnets = [ aws_default_subnet.subnet_1.id, aws_default_subnet.subnet_2.id ] 
  count = var.production ? 1 : 0
}

resource "aws_default_vpc" "DefaultVPC" {
}

resource "aws_lb_target_group" "lbTarget" {
  name = "targetInstances"
  port = "8000"
  protocol = "HTTP"
  vpc_id = aws_default_vpc.DefaultVPC.id
  count = var.production ? 1 : 0
}

resource "aws_lb_listener" "lbListener" {
  load_balancer_arn = aws_lb.loadBalancer[0].arn
  port = "8000"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lbTarget[0].arn
  }
  count = var.production ? 1 : 0
}

resource "aws_autoscaling_policy" "ScalingPolicy" {
  name = "scale_policy"
  autoscaling_group_name = var.group_name
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
  count = var.production ? 1 : 0
}
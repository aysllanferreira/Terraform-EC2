module "aws-dev" {
  source = "../../infra"
  instance = "t2.micro"
  aws_region = "us-east-1"
  sshKeys = "IaC-DEV"
  instance_name = "First Terraform Dev Instance"
  security_group_name = "general_group"
  group_name = "Dev-ASG"
  max_size = 0
  min_size = 1
  production = false
}

module "aws-prod" {
  source = "../../infra"
  instance = "t2.micro"
  aws_region = "us-east-1"
  sshKeys = "IaC-Prod"
  instance_name = "First Terraform Prod Instance"
  security_group_name = "general_group_prod"
  group_name = "Prod-ASG"
  max_size = 10
  min_size = 1
  production = true
}

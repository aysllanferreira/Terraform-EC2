module "aws-prod" {
  source = "../../infra"
  instance = "t2.micro"
  aws_region = "us-east-1"
  sshKeys = "IaC-Prod"
  instance_name = "First Terraform Prod Instance"
  security_group_name = "general_group_prod"
}

output "PROD" {
  value = module.aws-prod.public_ip
}
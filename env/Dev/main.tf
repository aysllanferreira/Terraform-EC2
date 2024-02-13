module "aws-dev" {
  source = "../../infra"
  instance = "t2.micro"
  aws_region = "us-east-1"
  sshKeys = "IaC-DEV"
  instance_name = "First Terraform Dev Instance"
  security_group_name = "general_group"
}

output "IP_DEV" {
  value = module.aws-dev.public_ip
}
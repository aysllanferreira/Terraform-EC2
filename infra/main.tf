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

resource "aws_instance" "app_server" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = var.instance
  key_name = var.sshKeys

  tags = {
    Name = var.instance_name
  }
}

resource "aws_key_pair" "sshKey" {
  key_name   = var.sshKeys
  public_key = file("${var.sshKeys}.pub")
}

output "public_ip" {
  value = aws_instance.app_server.public_ip
}
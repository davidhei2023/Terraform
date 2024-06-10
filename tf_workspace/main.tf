
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.30.0"
    }
  }
  backend "s3" {
    bucket = "davidhei-tf-state"
    key    = "tfstate.json"
    region = "us-east-2"
    # optional: dynamodb_table = "<table-name>"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.region
  #profile = "<aws-course-profile>" #can change to default also
}

resource "aws_instance" "app_server" {
  ami = var.ami_id
  instance_type = var.instance_type
  #user_data = file(".terraform/deploy.sh")
  key_name = var.key_name

  tags = {
    Name = "davidhei-Terraform-${var.env}"
    Terraform = "true"
  }
}

data "aws_availability_zones" "available_azs" {
  state = "available"
}
data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical owner ID for Ubuntu AMIs

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

module "app_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "davidhei-new-vpc-tf"
  cidr = "10.0.0.0/16"

  azs             = data.aws_availability_zones.available_azs.names
  private_subnets = ["10.0.10.0/24", "10.0.11.0/24"]
  public_subnets  = ["10.0.12.0/24", "10.0.13.0/24"]

  enable_nat_gateway = false

  tags = {
    Name        = "davidhei-new-vpc"
    Env         = var.env
    Terraform   = true
  }
}

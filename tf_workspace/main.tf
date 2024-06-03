
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.16"
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
  instance_type = "t2.micro"
  user_data = file(".terraform/deploy.sh")
  key_name = var.key_name

  tags = {
    Name = "davidhei-ngnix-terraform-${var.env}"
    Terraform = "true"
  }
}

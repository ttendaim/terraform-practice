
provider "aws" {
    region = "eu-central-1"
}


resource "random_string" "suffix" {
  length  = 6
  lower   = true
  upper   = false
  numeric = true
  special = false
}

resource "aws_s3_bucket" "prod-bucket" {
  bucket = local.full_bucket_name


  tags = {
    Name = "prod-bucket"
  }
}

resource "aws_vpc" "prod_vpc" {

  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name       = "prod_vpc"
    Enviroment = var.environment

  }
}
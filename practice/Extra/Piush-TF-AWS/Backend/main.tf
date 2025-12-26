terraform {
    backend "s3" {
        bucket = "bagidhi-dev-1512"
        key   = "prod/terraform.tfstate"
        region = "eu-central-1"
        encrypt = true
        use_lockfile = true
    }

    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.67.0"

        }

        random = {
            source = "hashicorp/random"
            version = "~> 3.7.2"
        }
    }
}

resource "aws_s3_bucket" "prod-bucket" {
    bucket = "bagidhi-prod-1512"


    tags = {
        Name = "prod-bucket"
    }
}

resource "aws_vpc" "prod_vpc" {

    cidr_block          = "10.0.0.0/16"
    enable_dns_support = true 
    enable_dns_hostnames = true

    tags = {
        Name = "prod_vpc"

    }
}
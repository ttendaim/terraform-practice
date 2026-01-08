terraform {
 backend "s3" {
    bucket       = "bagidhi-dev-1512"
    key          = "prod/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
  }

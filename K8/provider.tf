provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    region  = "eu-west-1"
    bucket  = "sf-test1-1"
    key     = "global/s3/terraform.tfstate"
    encrypt = true
  }
}


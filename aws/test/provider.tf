terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "romank"
  shared_credentials_file = "/home/roman/.aws/credentials"
  region = var.region
}

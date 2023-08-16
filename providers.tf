provider "aws" {
  region  = "us-east-1" # Change to your desired region
  version = "~> 5.0"
}

terraform {
  backend "s3" {}
}
provider "aws" {
  version = "~> 2.33"
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket         = "tgedr-graphql-dev-terraform-state"
    key            = "graphql-api"
    region         = "eu-west-1"
    dynamodb_table = "tgedr-graphql-dev-terraform-state-lock"
    encrypt        = true
  }
}

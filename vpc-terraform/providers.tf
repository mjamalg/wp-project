terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.64.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "2.15.0"
    }
  }
}


provider "aws" {
  region = "us-east-1"
  profile = "terraformuser"

}

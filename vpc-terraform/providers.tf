terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.64.0"
    }
  }
}


provider "aws" {
  region = "us-east-1"
  profile = "< I perfer to use the AWS_PROFILE env variable, if you also use it put it here >"
 
   #Place your AWS Credentials here if you don't use the AWS_PROFILE env variable

}

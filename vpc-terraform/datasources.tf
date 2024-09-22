data "aws_region" "current" {
  name = "us-east-1"
}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}
 
data "aws_route53_zone" "chrysalient-zone" {
  name = "chrysalient.com"
}



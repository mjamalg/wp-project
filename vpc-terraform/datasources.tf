data "aws_region" "current" {
  # change to desired region
  name = "us-east-1"
}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

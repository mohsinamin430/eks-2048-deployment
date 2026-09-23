variable "aws_region" {
  default = "eu-west-2"
}

variable "tags" {
  default = {
    Environment = "prod"
    Project     = "eks-2048-deployment"
  }
}
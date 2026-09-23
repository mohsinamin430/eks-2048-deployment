terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.66.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    bucket       = "eks-2048-deployment"
    key          = "global/state/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}

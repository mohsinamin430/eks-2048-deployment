resource "aws_s3_bucket" "eks-2048-deployment" {
  bucket = "eks-2048-deployment"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "eks-2048-deployment" {
  bucket = aws_s3_bucket.eks-2048-deployment.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_ecr_repository" "eks-2048-deployment" {
  name                 = "eks-2048-deployment"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
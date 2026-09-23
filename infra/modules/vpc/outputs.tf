output "vpc_id" {
  value = aws_vpc.eks_2048_deployment.id
}

output "private_subnet_ids" {
  value = [for key, subnet in aws_subnet.eks_subnets :
    subnet.id
  if var.subnets[key].type == "private"]
}

output "public_subnet_ids" {
  value = [for key, subnet in aws_subnet.eks_subnets :
    subnet.id
  if var.subnets[key].type == "public"]
}

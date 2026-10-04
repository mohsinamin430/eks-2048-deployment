variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "cluster_version" {
  type    = string
  default = "1.36"
}

variable "eks_node_group_role_arn" {
  type = string
}

variable "eks_cluster_role_arn" {
  type = string
}

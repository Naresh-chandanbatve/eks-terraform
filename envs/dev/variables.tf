variable "env" {
  default = "dev"
}

variable "aws_region" { default = "eu-north-1" }

variable "cluster_name" { default = "dev-eks-cluster" }

variable "cluster_version" { default = "1.30" }

variable "instance_type" { default = "t3.medium" }

variable "desired_size" { default = 1 }
variable "min_size" { default = 1 }
variable "max_size" { default = 2 }

variable "cluster_endpoint_public_access" {
  type    = bool
  default = true
}

variable "cluster_endpoint_private_access" {
  type    = bool
  default = true
}

variable "cluster_endpoint_public_access_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "tags" {}

variable "node_groups" {}


variable "vpc_cidr" {
  default = "10.10.0.0/16"
}

variable "vpc_name" {
  default = "dev-vpc"
}

variable "azs" {
  default = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
}

variable "public_subnets" {
  default = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
}

variable "private_subnets" {
  default = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
}
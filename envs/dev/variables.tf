variable "env" {
  default = "dev"
}

variable "aws_region" { default = "eu-west-1" }

variable "cluster_name" { default = "dev-eks-cluster" }

variable "cluster_version" { default = "1.30" }

variable "instance_type" { default = "t3.small" }

variable "desired_size" { default = 1 }
variable "min_size" { default = 1 }
variable "max_size" { default = 2 }

variable "cluster_endpoint_public_access" {
  type    = bool
  default = false
}

variable "cluster_endpoint_private_access" {
  type    = bool
  default = true
}

variable "cluster_endpoint_public_access_cidrs" {
  type    = list(string)
  default = ["YOUR_IP/32"]
}

variable "tags" {}

variable "node_groups" { type = map(any) }

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  default = "dev-vpc"
}

variable "azs" {
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "public_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}


variable "enable_ingress_nginx" {

}

variable "enable_cert_manager" {

}

variable "enable_metrics_server" {

}

variable "enable_karpenter" {

}

variable "enable_kube_prometheus_stack" {

}
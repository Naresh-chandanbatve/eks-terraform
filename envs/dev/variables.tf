variable "aws_region" { default = "eu-north-1" }

variable "cluster_name" { default = "dev-eks-cluster" }

variable "cluster_version" { default = "1.30" }

variable "instance_type" { default = "t3.medium" }

variable "desired_size" { default = 1 }
variable "min_size"     { default = 1 }
variable "max_size"     { default = 2 }

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

variable "iam_users" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}
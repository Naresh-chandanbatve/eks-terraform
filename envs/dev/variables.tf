variable "aws_region" { default = "ap-south-1" }

variable "cluster_name" { default = "dev-eks-cluster" }

variable "cluster_version" { default = "1.27" }

variable "instance_type" { default = "t3.medium" }

variable "desired_size" { default = 1 }
variable "min_size"     { default = 1 }
variable "max_size"     { default = 2 }

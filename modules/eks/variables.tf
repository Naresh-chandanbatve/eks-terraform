variable "cluster_name"     { type = string }
variable "cluster_version"  { type = string }
variable "vpc_id"           { type = string }
variable "subnets"          { type = list(string) }

variable "node_groups" {
  type = map(any)
}

variable "tags" { 
    type = map(string) 
    default = {} 
    }

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
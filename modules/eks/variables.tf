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

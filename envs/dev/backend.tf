terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "eks-terra-naresh"
    workspaces {
      name = "eks-terraform"
    }
  }
}

output "cluster_name" { value = module.eks.cluster_name }
output "cluster_endpoint" { value = module.eks.cluster_endpoint }
output "cluster_certificate_authority_data" { value = module.eks.cluster_certificate_authority_data }
output "cluster_version" {
  value = module.eks.cluster_version
}
output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}
output "iam_role_name" {
  value = module.eks.eks_managed_node_groups["default"].iam_role_name
}

output "iam_role_arn" {
  value = module.eks.eks_managed_node_groups["default"].iam_role_arn
}
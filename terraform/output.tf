
output "eks_cluster_name" {
  description = "Nome do cluster EKS"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint da API do cluster EKS"
  value       = module.eks.cluster_endpoint
}


output "ecr_repository_url" {
  description = "URL do repositório ECR para push das imagens"
  value       = module.eks.ecr_repository_url
}
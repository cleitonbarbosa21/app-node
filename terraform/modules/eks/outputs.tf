output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_arn" {
  value = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "ecr_repository_arn" {
  value = aws_ecr_repository.this[*].arn
}

output "ecr_repository_url" {
  value = aws_ecr_repository.this.repository_url
}
resource "aws_eks_access_entry" "admin_role" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = "arn:aws:iam::743207691822:role/admin-role"
  type          = "STANDARD"
}


resource "aws_eks_access_policy_association" "admin_role" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = "arn:aws:iam::743207691822:role/admin-role"

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}
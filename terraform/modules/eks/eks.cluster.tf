
#### EKS Cluster

resource "aws_eks_cluster" "this" {
  name                      = "arcampos-eks-cluster"
  version                   = var.cluster_version
  role_arn                  = aws_iam_role.eks_cluster.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_public_access  = true
    endpoint_private_access = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
  ]
}




#### IAM Roles and Policies for EKS Cluster

resource "aws_iam_role" "eks_cluster" {
  name = "arcampos-eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}





#### Node Group

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "arcampos-eks-cluster-ng"
  node_role_arn   = aws_iam_role.eks_cluster_ng.arn
  subnet_ids      = var.subnet_ids
  instance_types  = [var.node_instance_type]
  capacity_type   = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_ng_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_cluster_ng_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_cluster_ng_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks_cluster_ng_AmazonSSMManagedInstanceCore
  ]
}



#### IAM Roles and Policies for EKS Node Group

resource "aws_iam_role" "eks_cluster_ng" {
  name = "arcampos-eks-cluster-ng-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_ng_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_cluster_ng.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_ng_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_cluster_ng.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_ng_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_cluster_ng.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_ng_AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eks_cluster_ng.name
}



### OIDC Provider and GitHub Actions Role for EKS Access
resource "aws_eks_access_entry" "github" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = var.github_role_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "github" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = var.github_role_arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}



### ECR Repository for Application Images
resource "aws_ecr_repository" "this" {
  name                 = "node-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "node-app"
  }
}

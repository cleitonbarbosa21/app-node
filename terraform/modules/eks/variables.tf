variable "project_name" {
  description = "Nome do projeto para tagueamento dos recursos"
  type        = string
}


variable "vpc_id" {
  description = "ID da VPC onde o cluster EKS será criado"
  type        = string
}


variable "subnet_ids" {
  type = list(string)
}


variable "cluster_version" {
  type = string
}

variable "node_instance_type" {
  description = "Tipo de instância dos nodes do EKS"
  type        = string
}


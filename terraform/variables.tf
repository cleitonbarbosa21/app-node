variable "project_name" {
  type    = string
  default = "arcampos"
}

variable "region" {
  type    = string
  default = "us-east-1"
}


variable "cluster_name" {
  type    = string
  default = "arcampos-eks-cluster"
}


variable "cluster_version" {
  type    = string
  default = "1.35"
}

variable "node_instance_type" {
  description = "Tipo de instância dos nodes do EKS"
  type        = string
  default     = "t3.medium"
}


variable "vpc" {
  type = object({
    name                     = string
    cidr_block               = string
    internet_gateway_name    = string
    nat_gateway_name         = string
    public_route_table_name  = string
    private_route_table_name = string
    public_subnets = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    }))
    private_subnets = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    }))
  })

  default = {
    name                     = "arcampos-tf-vpc"
    cidr_block               = "10.0.0.0/24"
    internet_gateway_name    = "arcampos-tf-igw"
    nat_gateway_name         = "arcampos-tf-ngw"
    public_route_table_name  = "arcampos-tf-public-rt"
    private_route_table_name = "arcampos-tf-private-rt"
    public_subnets = [{
      name                    = "arcampos-tf-public-subnet-us-east-1a"
      cidr_block              = "10.0.0.0/26"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = true
      },
      {
        name                    = "arcampos-tf-public-subnet-us-east-1b"
        cidr_block              = "10.0.0.64/26"
        availability_zone       = "us-east-1b"
        map_public_ip_on_launch = true
    }]
    private_subnets = [{
      name                    = "arcampos-tf-private-subnet-us-east-1a"
      cidr_block              = "10.0.0.128/26"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = false
      },
      {
        name                    = "arcampos-tf-private-subnet-us-east-1b"
        cidr_block              = "10.0.0.192/26"
        availability_zone       = "us-east-1b"
        map_public_ip_on_launch = false
    }]
  }
}





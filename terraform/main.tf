terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "cleiton-containers-statefiles"
    key    = "project/dev/state"
    region = "us-east-1"
  }
}


provider "aws" {
  region = var.region

}

module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  region       = var.region
  vpc          = var.vpc
}

module "eks" {
  source = "./modules/eks"

  project_name       = var.project_name
  vpc_id             = module.networking.vpc_id
  subnet_ids         = module.networking.private_subnet_ids
  cluster_version    = var.cluster_version
  node_instance_type = var.node_instance_type
}
# 1. Read the state outputs from your core infrastructure folder
# data "terraform_remote_state" "infra" {
#   backend = "s3"  # if you migrated your infra state to an S3 bucket

#   config = {
#     path = "../infra/terraform.tfstate" # Points back to your core infra directory
#   }
# }

data "aws_caller_identity" "current" {}

data "aws_vpc" "this" {
  id = data.aws_eks_cluster.this.vpc_config[0].vpc_id
}

# 2. Use those remote inputs to dynamically authenticate the Helm & Kubernetes providers
provider "aws" {
  region = "ap-south-2"
}

data "aws_eks_cluster" "this" {
  name = "ecommerce-app-eks"
}

data "aws_eks_cluster_auth" "this" {
  name = "ecommerce-app-eks"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(
    data.aws_eks_cluster.this.certificate_authority[0].data
  )
  token = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(
      data.aws_eks_cluster.this.certificate_authority[0].data
    )
    token = data.aws_eks_cluster_auth.this.token
  }
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "example"
  kubernetes_version = "1.33"

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = "vpc-0c87f4bc406de9d2f"
  subnet_ids = ["subnet-0068375b958e9b782", "subnet-03837b3fff98c32f8"]
    
  tags = {
    Environment = var.env
    Terraform   = "true"
  }
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "ecommerce-app-eks"
  kubernetes_version = "1.33"

  endpoint_public_access  = true
  endpoint_private_access = true

  enable_cluster_creator_admin_permissions = true

  compute_config = {
    enabled = false
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  node_security_group_enable_recommended_rules = true

  eks_managed_node_groups = {
    app_nodes = {
      name           = "ecommerce-app-worker-nodes"
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 1

      capacity_type = "ON_DEMAND" 

      iam_role_use_name_prefix = false
      iam_role_name            = "eks-app-node-role"

      create_iam_role                       = true
      attach_cluster_primary_security_group = true
    }
  }
    
  tags = {
    Environment = var.env
    Terraform   = "true"
  }
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = module.eks.cluster_name
  addon_name   = "vpc-cni"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_eks_addon" "coredns" {
  cluster_name = module.eks.cluster_name
  addon_name   = "coredns"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = module.eks.cluster_name
  addon_name   = "kube-proxy"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}
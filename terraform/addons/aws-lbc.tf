# 1. Create the IAM Role for Service Accounts (IRSA)
module "load_balancer_controller_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.30"

  role_name                              = "aws-load-balancer-controller-${var.env}"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}"
      # data.aws_eks_cluster.this.identity[0].oidc[0].issuer

      # "arn:aws:iam::622915751178:oidc-provider/oidc.eks.ap-south-2.amazonaws.com/id/D4665B897692BE71F18DC73915EE6F4D"
                      # data.terraform_remote_state.infra.outputs.cluster_oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

# 2. Deploy the AWS Load Balancer Controller via Helm
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.7.2"

  set {
    name  = "clusterName"
    value = data.aws_eks_cluster.this.name
  }

  set {
    name  = "vpcId"
    value = data.aws_vpc.this.id
  }

  set {
    name  = "region"
    value = "ap-south-2" 
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.load_balancer_controller_irsa_role.iam_role_arn
  }
}
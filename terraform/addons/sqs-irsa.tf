module "backend_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.30"

  role_name = "backend-sqs-role"

  oidc_providers = {
    main = {
      provider_arn               = "arn:aws:iam::622915751178:oidc-provider/${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}"
      namespace_service_accounts = ["ecommerce-app-ns:backend-sa"]
    }
  }
}

resource "aws_iam_role_policy" "backend_sqs" {
  name = "backend-sqs-access"
  role = module.backend_irsa_role.iam_role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
      Resource = aws_sqs_queue.ecommerce_queue.arn
    }]
  })
}
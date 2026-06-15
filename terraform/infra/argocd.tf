# 1. Create the dedicated namespace for ArgoCD
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

# 2. Deploy ArgoCD using the official Helm Chart
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.1.3" # Uses a stable, production-ready chart version
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  # Optional but recommended configuration overrides
#   set {
#     name  = "server.service.type"
#     value = "ClusterIP" # Keep it internal; we will expose it securely later via Ingress
#   }

#   set {
#     name  = "configs.secret.argocdServerAdminPasswordMuted"
#     value = "false"
#   }
}
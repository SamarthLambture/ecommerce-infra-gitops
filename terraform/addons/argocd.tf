resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.1.3" 
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  set {
    name  = "server.service.type"
    value = "ClusterIP" 
  }

  set {
    name  = "configs.secret.argocdServerAdminPasswordMuted"
    value = "false"
  }

  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }
  set {
    name  = "server.metrics.enabled"
    value = "true"
  }
  set {
    name  = "repoServer.metrics.enabled"
    value = "true"
  }
}
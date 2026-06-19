resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "prometheus_stack" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "61.3.0" # Stable tracking version
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  # For a development/learning setup, we can disable persistent storage 
  # so it doesn't try to provision expensive AWS EBS volumes right away.
  set {
    name  = "prometheus.prometheusSpec.storageSpec.emptyDir.medium"
    value = "Memory"
  }

  # Ensure Grafana is enabled and ready
  set {
    name  = "grafana.enabled"
    value = "true"
  }

  depends_on = [data.aws_eks_cluster.this]
}
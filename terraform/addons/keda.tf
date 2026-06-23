resource "kubernetes_namespace" "keda" {
  metadata {
    name = "keda"
  }
}

resource "helm_release" "keda" {
  name       = "keda"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  version    = "2.14.0" # Use the latest stable version suited for your setup
  namespace  = kubernetes_namespace.keda.metadata[0].name

  # --- Senior DevOps Tweak: Enable Prometheus Scraping ---
  set {
    name  = "prometheus.metricServer.enabled"
    value = "true"
  }

  set {
    name  = "prometheus.metricServer.podMonitor.enabled"
    value = "true"
  }

  set {
    name  = "prometheus.operator.enabled"
    value = "true"
  }
  # KEDA can run perfectly fine on your existing node groups
  # depends_on = [data.aws_eks_cluster.this]
  depends_on = [helm_release.aws_load_balancer_controller]
}
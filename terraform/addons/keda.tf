resource "kubernetes_namespace" "keda" {
  metadata {
    name = "keda"
  }
}

resource "helm_release" "keda" {
  name       = "keda"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  version    = "2.14.0" 
  namespace  = kubernetes_namespace.keda.metadata[0].name


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

  depends_on = [helm_release.aws_load_balancer_controller]
}
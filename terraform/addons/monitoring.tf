# resource "kubernetes_namespace" "monitoring" {
#   metadata {
#     name = "monitoring"
#   }
# }

# resource "helm_release" "prometheus_stack" {
#   name       = "prometheus"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   chart      = "kube-prometheus-stack"
#   version    = "61.3.0" # Stable tracking version
#   namespace  = kubernetes_namespace.monitoring.metadata[0].name

#   # For a development/learning setup, we can disable persistent storage 
#   # so it doesn't try to provision expensive AWS EBS volumes right away.
#   set {
#     name  = "prometheus.prometheusSpec.storageSpec"
#     value = ""
#   }

#   # Ensure Grafana is enabled and ready
#   set {
#     name  = "grafana.enabled"
#     value = "true"
#   }

#   depends_on = [data.aws_eks_cluster.this]
# }


resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "prometheus_stack" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "61.3.0"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues"
    value = "false"
  }
  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = "false"
  }
  set {
    name  = "prometheus.prometheusSpec.ruleSelectorNilUsesHelmValues"
    value = "false"
  }

  set {
    name  = "grafana.service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "grafana.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "external"
  }
  set {
    name  = "grafana.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-nlb-target-type"
    value = "ip"
  }
  set {
    name  = "grafana.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
    value = "internet-facing"
  }

  set {
    name  = "grafana.sidecar.dashboards.enabled"
    value = "true"
  }
  set {
    name  = "grafana.sidecar.dashboards.label"
    value = "grafana_dashboard"
  }
  set {
    name  = "grafana.sidecar.dashboards.labelValue"
    value = "1"
  }
  set {
    name  = "grafana.sidecar.dashboards.searchNamespace"
    value = "ALL"  
  }

  set {
    name  = "prometheus.prometheusSpec.storageSpec"
    value = ""
  }
  set {
    name  = "grafana.persistence.enabled"
    value = "false"
  }

  depends_on = [data.aws_eks_cluster.this]
}

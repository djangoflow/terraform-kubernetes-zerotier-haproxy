resource "kubernetes_service_v1" "service" {
  for_each = var.services
  metadata {
    namespace = var.namespace
    name      = each.key
  }
  spec {
    selector = local.selector_labels
    type = "ClusterIP"
    port {
      name        = "http"
      port        = 80
      protocol    = "TCP"
      target_port = each.value.local_port
    }
  }
}
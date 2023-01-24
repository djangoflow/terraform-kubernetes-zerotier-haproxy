resource "kubernetes_deployment" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = local.selector_labels
  }

  spec {
    replicas = 1
    selector {
      match_labels = local.selector_labels
    }

    template {
      metadata {
        labels = local.selector_labels
      }

      spec {
        host_network = true
        dns_policy = "ClusterFirstWithHostNet"

        container {
          name              = "zerotier"
          image             = "zerotier/zerotier"
          image_pull_policy = "IfNotPresent"
          args              = var.zt_networks
          security_context {
            capabilities {
              add = ["NET_ADMIN", "NET_RAW", "SYS_ADMIN"]
            }
            privileged = true
          }
          env {
            name  = "ZEROTIER_IDENTITY_PUBLIC"
            value = var.zt_identity_public
          }
          env {
            name  = "ZEROTIER_IDENTITY_SECRET"
            value = var.zt_identity_secret
          }
          env {
            name  = "MASQUERADE"
            value = var.enable_masquerade
          }
          resources {
            limits = {
              cpu    = "150m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
          }
          volume_mount {
            name       = "dev-net-tun"
            mount_path = "/dev/net/tun"
          }
          volume_mount {
            name       = "ztdata"
            mount_path = "/var/lib/zerotier-one"
          }
        }
        dynamic container {
          for_each = length(keys(var.services)) == 0 ? [] : [1]
          content {
            name              = "haproxy"
            image             = "haproxy"
            image_pull_policy = "IfNotPresent"
            dynamic "port" {
              for_each = var.services
              content {
                container_port = port.value.local_port
                host_port      = port.value.local_port
              }
            }
            resources {
              limits = {
                cpu    = "150m"
                memory = "512Mi"
              }
              requests = {
                cpu    = "50m"
                memory = "64Mi"
              }
            }
            volume_mount {
              mount_path = "/usr/local/etc/haproxy/haproxy.cfg"
              sub_path   = "haproxy.cfg"
              name       = "haproxy-config"
            }
          }
        }
        volume {
          name = "dev-net-tun"
          host_path {
            path = "/dev/net/tun"
          }
        }
        volume {
          name = "ztdata"
          empty_dir {}
        }
        volume {
          name = "haproxy-config"
          config_map {
            name = kubernetes_config_map_v1.haproxy-config.metadata.0.name
          }
        }
      }
    }

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_unavailable = "10%"
      }
    }
  }
}

resource "kubernetes_config_map_v1" "haproxy-config" {
  metadata {
    namespace = var.namespace
    name      = "haproxy-config"
  }
  data = {
    "haproxy.cfg" : <<EOT
global
defaults
  timeout client      30s
  timeout server      30s
  timeout connect     30s

%{ for k,v in var.services }
frontend ${k}
  bind *:${v.local_port}
  mode http
  default_backend ${k}
%{ endfor }
%{ for k,v in var.services }
backend ${k}
  mode http
  server ${k} ${v.remote_ip}:${v.remote_port}
%{ endfor }
EOT
  }
}

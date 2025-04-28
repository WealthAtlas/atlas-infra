resource "kubernetes_deployment" "bff" {
  metadata {
    name      = "nestjs-bff"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        app = "nestjs-bff"
      }
    }
    template {
      metadata {
        labels = {
          app = "nestjs-bff"
        }
      }
      spec {
        image_pull_secrets {
          name = kubernetes_secret.ghcr_secret.metadata[0].name
        }
        container {
          name  = "nestjs-bff"
          image = "ghcr.io/YOUR_GITHUB_USER/YOUR_BFF_IMAGE:latest"

          env {
            name  = "BACKEND_URL"
            value = "http://spring-backend:8080"
          }

          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "bff" {
  metadata {
    name      = "nestjs-bff"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = "nestjs-bff"
    }
    port {
      port        = 3000
      target_port = 3000
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_ingress" "bff_ingress" {
  metadata {
    name      = "bff-ingress"
    namespace = var.namespace
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      http {
        path {
          path = "/api"
          backend {
            service_name = kubernetes_service.bff.metadata[0].name
            service_port = 3000
          }
        }
      }
    }
  }
}

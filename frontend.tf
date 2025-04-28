resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "nextjs-frontend"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        app = "nextjs-frontend"
      }
    }
    template {
      metadata {
        labels = {
          app = "nextjs-frontend"
        }
      }
      spec {
        image_pull_secrets {
          name = kubernetes_secret.ghcr_secret.metadata[0].name
        }
        container {
          name  = "nextjs-frontend"
          image = "ghcr.io/YOUR_GITHUB_USER/YOUR_FRONTEND_IMAGE:latest"

          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name      = "nextjs-frontend"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = "nextjs-frontend"
    }
    port {
      port        = 3000
      target_port = 3000
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_ingress" "frontend_ingress" {
  metadata {
    name      = "frontend-ingress"
    namespace = var.namespace
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      http {
        path {
          path     = "/"
          backend {
            service_name = kubernetes_service.frontend.metadata[0].name
            service_port = 3000
          }
        }
      }
    }
  }
}
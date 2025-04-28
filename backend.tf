resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "spring-backend"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        app = "spring-backend"
      }
    }
    template {
      metadata {
        labels = {
          app = "spring-backend"
        }
      }
      spec {
        image_pull_secrets {
          name = kubernetes_secret.ghcr_secret.metadata[0].name
        }
        container {
          name  = "spring-backend"
          image = "ghcr.io/YOUR_GITHUB_USER/YOUR_BACKEND_IMAGE:latest"

          env {
            name  = "SPRING_DATASOURCE_URL"
            value = "jdbc:postgresql://postgres:5432/postgres"
          }

          env {
            name  = "SPRING_DATASOURCE_PASSWORD"
            value = var.postgres_password
          }

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "backend" {
  metadata {
    name      = "spring-backend"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = "spring-backend"
    }
    port {
      port        = 8080
      target_port = 8080
    }
    type = "ClusterIP"
  }
}
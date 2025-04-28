variable "namespace" {
  default = "my-app"
}

variable "postgres_password" {
  description = "Password for Postgres user"
  default     = "postgrespassword"
}

variable "ghcr_username" {
  description = "GitHub Container Registry username"
}

variable "ghcr_token" {
  description = "GitHub Container Registry token (for pulling private images)"
}
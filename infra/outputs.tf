output "app_url" {
  value = "https://${azurerm_container_app.app.latest_revision_fqdn}"
}

output "docker_images" {
  value = {
    nginx = "ghcr.io/${var.github_username}/nginx:${var.image_tag}"
    web   = "ghcr.io/${var.github_username}/web:${var.image_tag}"
    api   = "ghcr.io/${var.github_username}/api:${var.image_tag}"
  }
}

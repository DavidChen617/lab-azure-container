terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# ── Resource Group ──────────────────────────────────────────────────────────

resource "azurerm_resource_group" "rg" {
  name     = "${var.project_name}-rg"
  location = var.location
}

# ── Container App Environment ──────────────────────────────────────────────

resource "azurerm_container_app_environment" "env" {
  name                = "${var.project_name}-env"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# ── Container App ──────────────────────────────────────────────────────────

resource "azurerm_container_app" "app" {
  name                         = "${var.project_name}-app"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  registry {
    server = "ghcr.io"
  }

  ingress {
    external_enabled = true
    target_port      = 80
    transport        = "http"
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    min_replicas = 1
    max_replicas = 2

    # total: 1.25 vCPU / 2.5Gi — 合法組合

    container {
      name   = "nginx"
      image  = "ghcr.io/${var.github_username}/nginx:${var.image_tag}"
      cpu    = 0.25
      memory = "0.5Gi"
    }

    container {
      name   = "web"
      image  = "ghcr.io/${var.github_username}/web:${var.image_tag}"
      cpu    = 0.5
      memory = "1.0Gi"
    }

    container {
      name   = "api"
      image  = "ghcr.io/${var.github_username}/api:${var.image_tag}"
      cpu    = 0.5
      memory = "1.0Gi"

      env {
        name  = "ASPNETCORE_URLS"
        value = "http://+:8080"
      }
    }
  }

}

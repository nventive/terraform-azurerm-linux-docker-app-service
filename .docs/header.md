![nventive](https://nventive-public-assets.s3.amazonaws.com/nventive_logo_github.svg?v=2)

# terraform-azurerm-linux-docker-app-service

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg?style=flat-square)](LICENSE) [![Latest Release](https://img.shields.io/github/release/nventive/terraform-azurerm-linux-docker-app-service.svg?style=flat-square)](https://github.com/nventive/terraform-azurerm-linux-docker-app-service/releases/latest)

Terraform module to provision an Azure Linux Web App (App Service) that runs a Docker image.

---

## Important Azure App Service Limitation

Please note that Azure App Service will terminate TSL/SSL at the front ends. That means that TLS/SSL requests never get to your app. You don't need to, and shouldn't implement any support for TLS/SSL into your app. The front ends are located inside Azure data centers. If you use TLS/SSL with your app, your traffic across the Internet will always be safely encrypted.

See [the following documentation](https://learn.microsoft.com/en-us/azure/app-service/configure-custom-container?pivots=container-linux&tabs=debian#detect-https-session).

## Examples

**IMPORTANT:** We do not pin modules to versions in our examples because of the difficulty of keeping the versions in
the documentation in sync with the latest released versions. We highly recommend that in your code you pin the version
to the exact version you are using so that your infrastructure remains stable, and update versions in a systematic way
so that they do not catch you by surprise.

### With a public registry

```hcl
module "echo_ghcr" {
  source = "nventive/linux-docker-app-service/azurerm"
  # We recommend pinning every module to a specific version
  # version = "x.x.x"

  resource_group_name     = azurerm_resource_group.example.name
  resource_group_location = azurerm_resource_group.example.location

  docker_registry_url = "https://ghcr.io"
  docker_image_name   = "mendhak/http-https-echo"
  docker_image_tag    = "latest"
  container_port      = 8080

  app_settings = {
    SOME_APP_SETTING = "foo"
  }
}
```

### With Azure Container Registry

```hcl
module "acr_with_role_assignment" {
  source = "nventive/linux-docker-app-service/azurerm"
  # We recommend pinning every module to a specific version
  # version = "x.x.x"

  resource_group_name     = azurerm_resource_group.example.name
  resource_group_location = azurerm_resource_group.example.location

  docker_registry_url = "https://${azurerm_container_registry.example.login_server}"
  docker_image_name   = "nginx"
  docker_image_tag    = "latest"
  container_port      = 80

  container_registry_use_managed_identity = true
  create_acr_role_assignment              = true
  acr_id                                  = azurerm_container_registry.example.id
}
```

### With Custom Domain

```hcl
module "with_custom_domain" {
  source = "nventive/linux-docker-app-service/azurerm"
  # We recommend pinning every module to a specific version
  # version = "x.x.x"

  resource_group_name     = azurerm_resource_group.example.name
  resource_group_location = azurerm_resource_group.example.location

  docker_registry_url = "https://ghcr.io"
  docker_image_name   = "mendhak/http-https-echo"
  docker_image_tag    = "latest"
  container_port      = 8080

  custom_sub_domain_name              = "echo"
  parent_dns_zone_name                = "parent-dns-zone"
  parent_dns_zone_resource_group_name = "some-resource-group"
}
```

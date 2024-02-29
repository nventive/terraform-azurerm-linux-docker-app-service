locals {
  custom_domain_enabled               = var.custom_sub_domain_name != null
  app_settings                        = merge(var.app_settings, { WEBSITES_PORT = var.container_port })
  parent_dns_zone_name                = join("", data.azurerm_dns_zone.parent.*.name)
  parent_dns_zone_resource_group_name = join("", data.azurerm_dns_zone.parent.*.resource_group_name)
}

resource "azurerm_service_plan" "default" {
  name                = module.this.id
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  os_type             = "Linux"
  sku_name            = var.sku_name
}

resource "azurerm_linux_web_app" "default" {
  name                = module.this.id
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  service_plan_id = azurerm_service_plan.default.id
  https_only      = var.https_only

  app_settings = local.app_settings

  site_config {
    always_on                               = var.app_service_always_on
    container_registry_use_managed_identity = var.container_registry_use_managed_identity

    application_stack {
      docker_registry_url = var.docker_registry_url
      docker_image_name   = "${var.docker_image_name}:${var.docker_image_tag}"
    }

    cors {
      allowed_origins = var.cors_allowed_origins
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = module.this.tags
}

resource "azurerm_role_assignment" "default" {
  count = var.create_acr_role_assignment ? 1 : 0

  role_definition_name = "AcrPull"
  scope                = var.acr_id
  principal_id         = azurerm_linux_web_app.default.identity.0.principal_id
}

data "azurerm_dns_zone" "parent" {
  count = local.custom_domain_enabled ? 1 : 0

  name                = var.parent_dns_zone_name
  resource_group_name = var.parent_dns_zone_resource_group_name
}

resource "azurerm_dns_txt_record" "txt_default" {
  count = local.custom_domain_enabled ? 1 : 0

  name                = "asuid.${var.custom_sub_domain_name}"
  zone_name           = local.parent_dns_zone_name
  resource_group_name = local.parent_dns_zone_resource_group_name
  ttl                 = 300

  record { value = azurerm_linux_web_app.default.custom_domain_verification_id }

  tags = module.this.tags
}

resource "azurerm_dns_cname_record" "cname_default" {
  count = local.custom_domain_enabled ? 1 : 0

  name                = var.custom_sub_domain_name
  zone_name           = local.parent_dns_zone_name
  resource_group_name = local.parent_dns_zone_resource_group_name
  ttl                 = 300
  record              = azurerm_linux_web_app.default.default_hostname

  tags = module.this.tags

  depends_on = [azurerm_dns_txt_record.txt_default]
}

resource "azurerm_app_service_custom_hostname_binding" "default" {
  count = local.custom_domain_enabled ? 1 : 0

  resource_group_name = var.resource_group_name

  hostname         = "${var.custom_sub_domain_name}.${local.parent_dns_zone_name}"
  app_service_name = azurerm_linux_web_app.default.name
}

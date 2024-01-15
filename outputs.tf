output "app_service_name" {
  value       = azurerm_linux_web_app.default.name
  description = "Created Azure App Service name"
}

output "app_service_id" {
  value       = azurerm_linux_web_app.default.id
  description = "The ID of the Linux Web App."
}

output "hostname" {
  value       = azurerm_linux_web_app.default.default_hostname
  description = "The default hostname of the Linux Web App."
}

output "custom_domain_verification_id" {
  value       = azurerm_linux_web_app.default.custom_domain_verification_id
  description = "The identifier used by App Service to perform domain ownership verification via DNS TXT record."
}

output "hosting_environment_id" {
  value       = azurerm_linux_web_app.default.hosting_environment_id
  description = "The ID of the App Service Environment used by App Service."
}

output "kind" {
  value       = azurerm_linux_web_app.default.kind
  description = "The Kind value for this Linux Web App."
}

output "outbound_ip_address_list" {
  value       = azurerm_linux_web_app.default.outbound_ip_address_list
  description = "A list of outbound IP addresses - such as [\"52.23.25.3\", \"52.143.43.12\"]."
}

output "outbound_ip_addresses" {
  value       = azurerm_linux_web_app.default.outbound_ip_addresses
  description = "A comma separated list of outbound IP addresses - such as 52.23.25.3, 52.143.43.12."
}

output "possible_outbound_ip_address_list" {
  value       = azurerm_linux_web_app.default.possible_outbound_ip_address_list
  description = "A list of possible outbound ip address."
}

output "possible_outbound_ip_addresses" {
  value       = azurerm_linux_web_app.default.possible_outbound_ip_addresses
  description = "A comma-separated list of outbound IP addresses - such as 52.23.25.3,52.143.43.12,52.143.43.17 - not all of which are necessarily in use. Superset of outbound_ip_addresses."
}

output "site_credential" {
  value       = azurerm_linux_web_app.default.site_credential
  description = "A site_credential block."
  sensitive   = true
}

output "identity" {
  value       = azurerm_linux_web_app.default.identity
  description = " An identity block, which contains the Managed Service Identity information for this App Service."
  sensitive   = true
}

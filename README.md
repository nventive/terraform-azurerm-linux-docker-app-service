<!-- BEGIN_TF_DOCS -->
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

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>3.86 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_app_service_custom_hostname_binding.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_custom_hostname_binding) | resource |
| [azurerm_dns_cname_record.cname_default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_cname_record) | resource |
| [azurerm_dns_txt_record.txt_default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_txt_record) | resource |
| [azurerm_linux_web_app.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app) | resource |
| [azurerm_role_assignment.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_service_plan.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [azurerm_dns_zone.parent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/dns_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_id"></a> [acr\_id](#input\_acr\_id) | Azure Container Registry ID to create role assignment for ACR\_Pull action. Only required to create a RBAC role for the App Service when using an Azure Container Registry as the image source. | `string` | `null` | no |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_app_service_always_on"></a> [app\_service\_always\_on](#input\_app\_service\_always\_on) | If this Linux Web App is Always On enabled. | `bool` | `true` | no |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | App Settings or environment variables to apply. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | The port number to which requests will be sent, corresponds to the port exposed by the container. | `number` | n/a | yes |
| <a name="input_container_registry_use_managed_identity"></a> [container\_registry\_use\_managed\_identity](#input\_container\_registry\_use\_managed\_identity) | Should connections for Azure Container Registry use Managed Identity. | `bool` | `false` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_cors_allowed_origins"></a> [cors\_allowed\_origins](#input\_cors\_allowed\_origins) | Specifies a list of origins that should be allowed to make cross-origin calls. | `list(string)` | `null` | no |
| <a name="input_create_acr_role_assignment"></a> [create\_acr\_role\_assignment](#input\_create\_acr\_role\_assignment) | Should a role assignment be created so that the App Service can pull the image from the Azure Container Registry. | `bool` | `false` | no |
| <a name="input_custom_sub_domain_name"></a> [custom\_sub\_domain\_name](#input\_custom\_sub\_domain\_name) | When creation a custom domain, the sub domain name to create. For example, for creating `myapp.contoso.com`, set the value `myapp`. | `string` | `null` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_docker_image_name"></a> [docker\_image\_name](#input\_docker\_image\_name) | The docker image name to be used. | `string` | n/a | yes |
| <a name="input_docker_image_tag"></a> [docker\_image\_tag](#input\_docker\_image\_tag) | The docker image tag to be used. | `string` | n/a | yes |
| <a name="input_docker_registry_url"></a> [docker\_registry\_url](#input\_docker\_registry\_url) | The URL of the container registry where the docker\_image\_name is located. e.g. https://index.docker.io or https://mcr.microsoft.com . | `string` | n/a | yes |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_https_only"></a> [https\_only](#input\_https\_only) | Should the Linux Web App require HTTPS connections. | `bool` | `true` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_parent_dns_zone_name"></a> [parent\_dns\_zone\_name](#input\_parent\_dns\_zone\_name) | When creating a custom domain, the name of the parent dns zone. | `string` | `null` | no |
| <a name="input_parent_dns_zone_resource_group_name"></a> [parent\_dns\_zone\_resource\_group\_name](#input\_parent\_dns\_zone\_resource\_group\_name) | When creating a custom domain, the name of the parent dns zone resource group. | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Location of the resource group to deploy the App Service to. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group to deploy the App Service to. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU for the plan. Possible values include B1, B2, B3, D1, F1, I1, I2, I3, I1v2, I2v2, I3v2, I4v2, I5v2, I6v2, P1v2, P2v2, P3v2, P0v3, P1v3, P2v3, P3v3, P1mv3, P2mv3, P3mv3, P4mv3, P5mv3, S1, S2, S3, SHARED, EP1, EP2, EP3, WS1, WS2, WS3, and Y1. | `string` | `"B1"` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_service_id"></a> [app\_service\_id](#output\_app\_service\_id) | The ID of the Linux Web App. |
| <a name="output_app_service_name"></a> [app\_service\_name](#output\_app\_service\_name) | Created Azure App Service name |
| <a name="output_custom_domain_verification_id"></a> [custom\_domain\_verification\_id](#output\_custom\_domain\_verification\_id) | The identifier used by App Service to perform domain ownership verification via DNS TXT record. |
| <a name="output_hosting_environment_id"></a> [hosting\_environment\_id](#output\_hosting\_environment\_id) | The ID of the App Service Environment used by App Service. |
| <a name="output_hostname"></a> [hostname](#output\_hostname) | The default hostname of the Linux Web App. |
| <a name="output_identity"></a> [identity](#output\_identity) | An identity block, which contains the Managed Service Identity information for this App Service. |
| <a name="output_kind"></a> [kind](#output\_kind) | The Kind value for this Linux Web App. |
| <a name="output_outbound_ip_address_list"></a> [outbound\_ip\_address\_list](#output\_outbound\_ip\_address\_list) | A list of outbound IP addresses - such as ["52.23.25.3", "52.143.43.12"]. |
| <a name="output_outbound_ip_addresses"></a> [outbound\_ip\_addresses](#output\_outbound\_ip\_addresses) | A comma separated list of outbound IP addresses - such as 52.23.25.3, 52.143.43.12. |
| <a name="output_possible_outbound_ip_address_list"></a> [possible\_outbound\_ip\_address\_list](#output\_possible\_outbound\_ip\_address\_list) | A list of possible outbound ip address. |
| <a name="output_possible_outbound_ip_addresses"></a> [possible\_outbound\_ip\_addresses](#output\_possible\_outbound\_ip\_addresses) | A comma-separated list of outbound IP addresses - such as 52.23.25.3,52.143.43.12,52.143.43.17 - not all of which are necessarily in use. Superset of outbound\_ip\_addresses. |
| <a name="output_site_credential"></a> [site\_credential](#output\_site\_credential) | A site\_credential block. |

## Breaking Changes

Please consult [BREAKING\_CHANGES.md](BREAKING\_CHANGES.md) for more information about version
history and compatibility.

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on the process for
contributing to this project.

Be mindful of our [Code of Conduct](CODE\_OF\_CONDUCT.md).

## We're hiring

Look for current openings on BambooHR https://nventive.bamboohr.com/careers/

## Stay in touch

[nventive.com](https://nventive.com/) | [Linkedin](https://www.linkedin.com/company/nventive/) | [Instagram](https://www.instagram.com/hellonventive/) | [YouTube](https://www.youtube.com/channel/UCFQyvGEKMO10hEyvCqprp5w) | [Spotify](https://open.spotify.com/show/0lsxfIb6Ttm76jB4wgutob)
<!-- END_TF_DOCS -->
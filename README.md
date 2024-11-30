## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_account) | resource |
| [aws_api_gateway_deployment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_domain_name.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name) | resource |
| [aws_api_gateway_method_settings.all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings) | resource |
| [aws_api_gateway_rest_api.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_stage.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |
| [aws_api_gateway_vpc_link.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_vpc_link) | resource |
| [aws_apigatewayv2_api_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api_mapping) | resource |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_wafv2_web_acl_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_ssm_parameter.subnets_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.vpc_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_endpoint_type"></a> [api\_endpoint\_type](#input\_api\_endpoint\_type) | Endpoint types - support values: EDGE or REGIONAL. If unspecified, defaults to EDGE. Must be declared as REGIONAL in non-Commercial partitions. | `string` | `null` | no |
| <a name="input_aws_api_gateway_domain_name"></a> [aws\_api\_gateway\_domain\_name](#input\_aws\_api\_gateway\_domain\_name) | custom domain for API | `string` | `null` | no |
| <a name="input_aws_api_gateway_domain_name_endpoint_configuration"></a> [aws\_api\_gateway\_domain\_name\_endpoint\_configuration](#input\_aws\_api\_gateway\_domain\_name\_endpoint\_configuration) | Endpoint types - support values: EDGE or REGIONAL. If unspecified, defaults to EDGE. Must be declared as REGIONAL in non-Commercial partitions. | `list(string)` | `[]` | no |
| <a name="input_aws_api_gateway_stage_prop"></a> [aws\_api\_gateway\_stage\_prop](#input\_aws\_api\_gateway\_stage\_prop) | aws\_api\_gateway\_stage\_prop | <pre>object({<br>    stage_name            = string<br>    xray_tracing_enabled  = bool<br>    cache_cluster_enabled = bool<br>    cache_cluster_size    = string<br>  })</pre> | n/a | yes |
| <a name="input_aws_lb_listener"></a> [aws\_lb\_listener](#input\_aws\_lb\_listener) | aws alb listener properties | <pre>object({<br>    port                = number<br>    protocol            = string<br>    default_action_type = string<br>  })</pre> | n/a | yes |
| <a name="input_aws_lb_target_group"></a> [aws\_lb\_target\_group](#input\_aws\_lb\_target\_group) | aws alb target group properties | <pre>object({<br>    target_type           = string<br>    port                  = number<br>    protocol              = string<br>    health_check_enabled  = bool<br>    healthy_threshold     = number<br>    unhealthy_threshold   = number<br>    health_check_timeout  = number<br>    health_check_port     = number<br>    health_check_path     = string<br>    health_check_protocol = string<br>    health_check_interval = number<br>    health_check_matcher  = string<br>  })</pre> | n/a | yes |
| <a name="input_cloudwatch_aws_iam_role_arn"></a> [cloudwatch\_aws\_iam\_role\_arn](#input\_cloudwatch\_aws\_iam\_role\_arn) | cloudwatch\_aws\_iam\_role\_arn | `string` | `""` | no |
| <a name="input_create_vpc_link"></a> [create\_vpc\_link](#input\_create\_vpc\_link) | To create vpc link or not | `bool` | `null` | no |
| <a name="input_custom_domain_regional_certificate_arn"></a> [custom\_domain\_regional\_certificate\_arn](#input\_custom\_domain\_regional\_certificate\_arn) | custom domain regional\_certificate\_arn | `string` | `null` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Additional resource tags | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | namespace to segregate the resources from other environment and used in the naming convention | `string` | `null` | no |
| <a name="input_org_name"></a> [org\_name](#input\_org\_name) | the org name to be used for naming convention | `string` | `null` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | the project name to be used for naming convention | `string` | `null` | no |
| <a name="input_region_name"></a> [region\_name](#input\_region\_name) | the region name to be used for naming convention | `string` | `null` | no |
| <a name="input_resource_desc"></a> [resource\_desc](#input\_resource\_desc) | the resource desc to be used for naming convention | `string` | `null` | no |
| <a name="input_subnet_ssm_id"></a> [subnet\_ssm\_id](#input\_subnet\_ssm\_id) | The parameter store path for subnets ids | `string` | `null` | no |
| <a name="input_targets"></a> [targets](#input\_targets) | target ip for ingress controller lb | <pre>list(object({<br>    ip   = string<br>    port = number<br>  }))</pre> | `[]` | no |
| <a name="input_vpc_ssm_id"></a> [vpc\_ssm\_id](#input\_vpc\_ssm\_id) | The parameter store path for vpc id | `string` | `null` | no |
| <a name="input_web_acl_arn"></a> [web\_acl\_arn](#input\_web\_acl\_arn) | WAF2 ACL ARN to be added to API Stage | `string` | `null` | no |

## Outputs

No outputs.

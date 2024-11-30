variable "org_name" {
  description = "the org name to be used for naming convention"
  type        = string
  default     = null
}

variable "project_name" {
  description = "the project name to be used for naming convention"
  type        = string
  default     = null
}

variable "region_name" {
  description = "the region name to be used for naming convention"
  type        = string
  default     = null
}

variable "resource_desc" {
  description = "the resource desc to be used for naming convention"
  type        = string
  default     = null
}

variable "environment" {
  type        = string
  description = "namespace to segregate the resources from other environment and used in the naming convention"
  default     = null
}

variable "create_vpc_link" {
  description = "To create vpc link or not"
  type        = bool
  default     = null
}

variable "cloudwatch_aws_iam_role_arn" {
  description = "cloudwatch_aws_iam_role_arn"
  default     = ""
  type        = string
}

variable "vpc_ssm_id" {
  description = "The parameter store path for vpc id"
  type        = string
  default     = null
}
variable "subnet_ssm_id" {
  description = "The parameter store path for subnets ids"
  type        = string
  default     = null
}

variable "web_acl_arn" {
  type        = string
  description = "WAF2 ACL ARN to be added to API Stage"
  default     = null
}

variable "aws_api_gateway_domain_name_endpoint_configuration" {
  description = "Endpoint types - support values: EDGE or REGIONAL. If unspecified, defaults to EDGE. Must be declared as REGIONAL in non-Commercial partitions."
  type        = list(string)
  default     = []
}

variable "api_endpoint_type" {
  description = "Endpoint types - support values: EDGE or REGIONAL. If unspecified, defaults to EDGE. Must be declared as REGIONAL in non-Commercial partitions."
  type        = string
  default     = null
}

variable "custom_domain_regional_certificate_arn" {
  description = "custom domain regional_certificate_arn"
  type        = string
  default     = null
}

variable "aws_api_gateway_domain_name" {
  description = "custom domain for API"
  type        = string
  default     = null
}

variable "default_tags" {
  description = "Additional resource tags"
  type        = map(string)
  default     = {}
}

variable "targets" {
  description = "target ip for ingress controller lb"
  type = list(object({
    ip   = string
    port = number
  }))
  default = []
}

variable "aws_lb_target_group" {
  description = "aws alb target group properties"
  type = object({
    target_type           = string
    port                  = number
    protocol              = string
    health_check_enabled  = bool
    healthy_threshold     = number
    unhealthy_threshold   = number
    health_check_timeout  = number
    health_check_port     = number
    health_check_path     = string
    health_check_protocol = string
    health_check_interval = number
    health_check_matcher  = string
  })
}

variable "aws_lb_listener" {
  description = "aws alb listener properties"
  type = object({
    port                = number
    protocol            = string
    default_action_type = string
  })
}

variable "aws_api_gateway_stage_prop" {
  description = "aws_api_gateway_stage_prop"
  type = object({
    stage_name            = string
    xray_tracing_enabled  = bool
    cache_cluster_enabled = bool
    cache_cluster_size    = string
  })
}
variable "rest_api_name" {
  type        = string
  description = "API Name."
}

variable "create_api_key" {
  description = "Whether to create the API key and associated resources"
  type        = bool
  default     = false
}

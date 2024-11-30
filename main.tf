data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_ssm_parameter" "vpc_id" {
  name = var.vpc_ssm_id
}
data "aws_ssm_parameter" "subnets_id" {
  name = var.subnet_ssm_id
}
locals {
  vpc_id     = nonsensitive(data.aws_ssm_parameter.vpc_id.value)
  subnet_ids = nonsensitive(split(",", data.aws_ssm_parameter.subnets_id.value))
}
locals {
  api_endpoint_type = var.api_endpoint_type
}
locals {
  id = "${var.org_name}-${var.region_name}-${var.environment}-${var.project_name}-${var.resource_desc}"
}

#data "aws_lb" "bsmp" {
#  arn = var.backend_app_alb_arn
#}

#data "aws_acm_certificate" "this" {
#  count = var.wildcard_certificate == false ? 1 : 0
#  domain   = "api.${var.default_domain}"
#  types       = ["IMPORTED"]
#  statuses = ["ISSUED"]
#}

#data "aws_acm_certificate" "om_wildcard" {
#  count = var.wildcard_certificate == true ? 1 : 0
#  domain   = "*.${var.default_domain}"
#  types       = ["IMPORTED"]
#  statuses = ["ISSUED"]
#}

resource "aws_lb" "this" {
  count              = var.create_vpc_link ? 1 : 0
  name               = "${local.id}-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = local.subnet_ids
  tags               = var.default_tags
}

resource "aws_lb_target_group" "this" {
  count       = var.create_vpc_link ? 1 : 0
  name        = "${local.id}-nlb"
  target_type = var.aws_lb_target_group.target_type
  port        = var.aws_lb_target_group.port
  protocol    = var.aws_lb_target_group.protocol
  vpc_id      = local.vpc_id
  tags        = var.default_tags
  health_check {
    enabled             = var.aws_lb_target_group.health_check_enabled
    healthy_threshold   = var.aws_lb_target_group.healthy_threshold
    unhealthy_threshold = var.aws_lb_target_group.unhealthy_threshold
    timeout             = var.aws_lb_target_group.health_check_timeout
    port                = var.aws_lb_target_group.health_check_port
    path                = var.aws_lb_target_group.health_check_path
    protocol            = var.aws_lb_target_group.health_check_protocol
    interval            = var.aws_lb_target_group.health_check_interval
    matcher             = var.aws_lb_target_group.health_check_matcher
  }
}

resource "aws_lb_target_group_attachment" "this" {
  count            = var.create_vpc_link ? length(var.targets) : 0
  target_group_arn = aws_lb_target_group.this[0].arn
  target_id        = element(var.targets, count.index).ip
  port             = element(var.targets, count.index).port
}

resource "aws_lb_listener" "this" {
  count             = var.create_vpc_link ? 1 : 0
  load_balancer_arn = aws_lb.this[0].arn
  port              = var.aws_lb_listener.port
  protocol          = var.aws_lb_listener.protocol
  tags              = var.default_tags

  default_action {
    type             = var.aws_lb_listener.default_action_type
    target_group_arn = aws_lb_target_group.this[0].arn
  }
}

resource "aws_api_gateway_vpc_link" "this" {
  count       = var.create_vpc_link ? 1 : 0
  name        = "${local.id}-vpc-link"
  target_arns = [aws_lb.this[0].arn]
  tags        = var.default_tags
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "api-gateway-execution-log-${local.id}"
  retention_in_days = 30
  tags              = var.default_tags
}

resource "aws_api_gateway_account" "this" {
  cloudwatch_role_arn = var.cloudwatch_aws_iam_role_arn != "" ? var.cloudwatch_aws_iam_role_arn : (length(aws_iam_role.this) > 0 ? aws_iam_role.this[0].arn : "")
}

resource "aws_iam_role" "this" {
  count              = var.cloudwatch_aws_iam_role_arn == "" ? 1 : 0
  name               = "AmazonAPIGatewayPushToCloudWatchLogs"
  tags               = var.default_tags
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch" {
  count = var.cloudwatch_aws_iam_role_arn == "" ? 1 : 0
  name  = "default"
  role  = aws_iam_role.this[0].id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_api_gateway_rest_api" "this" {
  depends_on  = [aws_api_gateway_vpc_link.this]
  name        = local.id
  description = local.id
  body        = file("${path.root}/api_body.json")
  endpoint_configuration {
    types = [local.api_endpoint_type]
  }
  tags = var.default_tags
}

resource "aws_api_gateway_deployment" "this" {
  depends_on = [aws_api_gateway_rest_api.this]
  ##module.customer-login, module.customer_v3, module.invite, module.root_proxy, module.signup, module.register,
  ##module.swagger_ui, module.user_id, module.users, aws_lambda_permission.redirect-lambda-permission
  rest_api_id       = aws_api_gateway_rest_api.this.id
  stage_description = "Deployed at ${timestamp()}"
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  depends_on            = [aws_cloudwatch_log_group.this]
  deployment_id         = aws_api_gateway_deployment.this.id
  rest_api_id           = aws_api_gateway_rest_api.this.id
  stage_name            = var.aws_api_gateway_stage_prop.stage_name
  xray_tracing_enabled  = var.aws_api_gateway_stage_prop.xray_tracing_enabled
  cache_cluster_enabled = var.aws_api_gateway_stage_prop.cache_cluster_enabled
  cache_cluster_size    = var.aws_api_gateway_stage_prop.cache_cluster_size
  tags                  = var.default_tags
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.this.arn
    format = jsonencode({
      "requestId" : "$context.requestId",
      "extendedRequestId" : "$context.extendedRequestId",
      "ip" : "$context.identity.sourceIp",
      "caller" : "$context.identity.caller",
      "user" : "$context.identity.user",
      "requestTime" : "$context.requestTime",
      "httpMethod" : "$context.httpMethod",
      "resourcePath" : "$context.resourcePath",
      "status" : "$context.status",
      "protocol" : "$context.protocol",
      "responseLength" : "$context.responseLength"
    })
  }
  #  variables = merge(var.backend_rest_api_variables, {
  #    "credentialsUrl" = "https://${var.bsmp_backend_alb_alias_record}/customer-account/users/me", deployed_at = timestamp(),
  #  })
}

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}


resource "aws_api_gateway_domain_name" "this" {
  depends_on               = [aws_api_gateway_stage.this]
  domain_name              = var.aws_api_gateway_domain_name
  regional_certificate_arn = var.custom_domain_regional_certificate_arn
  ##var.wildcard_certificate ? data.aws_acm_certificate.om_wildcard[0].id : data.aws_acm_certificate.this[0].id
  tags = var.default_tags
  endpoint_configuration {
    types = var.aws_api_gateway_domain_name_endpoint_configuration
  }
}

resource "aws_apigatewayv2_api_mapping" "this" {
  depends_on  = [aws_api_gateway_stage.this, aws_api_gateway_rest_api.this, aws_api_gateway_domain_name.this]
  api_id      = aws_api_gateway_rest_api.this.id
  domain_name = aws_api_gateway_domain_name.this.domain_name
  stage       = aws_api_gateway_stage.this.stage_name
}

resource "aws_wafv2_web_acl_association" "this" {
  count        = var.web_acl_arn != "" ? 1 : 0
  resource_arn = aws_api_gateway_stage.this.arn
  web_acl_arn  = var.web_acl_arn
}
resource "aws_api_gateway_usage_plan" "usage_plan" {
  count = var.create_api_key ? 1 : 0

  name = var.rest_api_name

  api_stages {
    api_id = aws_api_gateway_rest_api.this.id
    stage  = aws_api_gateway_stage.this.stage_name
  }
}

resource "aws_api_gateway_api_key" "api_key" {
  count = var.create_api_key ? 1 : 0

  name = var.rest_api_name
}

resource "aws_api_gateway_usage_plan_key" "plan_key" {
  count = var.create_api_key ? 1 : 0

  key_id        = aws_api_gateway_api_key.api_key[count.index].id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage_plan[count.index].id
}


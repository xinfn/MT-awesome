# create API-Gateway
resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "${var.api_gateway_name}"
  description = "MT CICD api-gateway test"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "api_proxy_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.api_gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.api_gateway.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "api_gateway_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api_gateway.id}"
  resource_id   = "${aws_api_gateway_resource.api_proxy_resource.id}"
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "mt_cicd_gateway_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.api_proxy_resource.id}"
  type        = "HTTP_PROXY"

  http_method             = "${aws_api_gateway_method.api_gateway_method.http_method}"
  integration_http_method = "ANY"
  uri                     = "http://${aws_lb.elb.dns_name}/{proxy}"

  request_parameters {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

# deployment
resource "aws_api_gateway_deployment" "mt_cicd_gateway_deployment" {
  depends_on = ["aws_api_gateway_integration.mt_cicd_gateway_integration"]

  rest_api_id = "${aws_api_gateway_rest_api.api_gateway.id}"
  stage_name  = "${var.api_gateway_stage_name}"
}

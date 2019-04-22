output "api-gateway-curl" {
  value = "${aws_api_gateway_deployment.mt_cicd_gateway_deployment.invoke_url}"
}

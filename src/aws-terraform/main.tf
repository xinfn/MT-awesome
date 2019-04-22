provider "aws" {
  region                  = "cn-northwest-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}

# ALB
resource "aws_lb" "elb" {
  name               = "${var.elb_name}"
  load_balancer_type = "application"
  subnets            = ["${var.elb_sub_nets}"]
  security_groups    = ["${var.elb_security_group}"]
}

# Create target group
resource "aws_lb_target_group" "target_group" {
  name     = "${var.elb_target_group}"
  port     = "8080"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

# Create listener for ALB, and bind target group
resource "aws_lb_listener" "elb_listener" {
  load_balancer_arn = "${aws_lb.elb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.target_group.id}"
    type             = "forward"
  }
}


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
  stage_name  = "test2"
}


# Auto Scaling

resource "aws_launch_template" "launch_template" {
  name_prefix   = "launch_template"
  image_id      = "${var.amzn2_ami_ecs_image_id}"
  instance_type = "t2.micro"

  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${var.ec2_security_group}"]

  iam_instance_profile {
    arn = "${var.ecs_instance_role_arn}"
  }

  user_data = "${var.ecs_container_user_data_base64}"
}

resource "aws_autoscaling_group" "ecs_autoscaling" {
  name                = "ECS-ecs_cluster_test-AutoScaling"
  availability_zones  = ["cn-northwest-1b"]                # only use ningxia zone now
  vpc_zone_identifier = ["${var.sub_net}"]
  max_size            = 1
  min_size            = 1
  desired_capacity    = 1
  health_check_type   = "EC2"

  launch_template {
    id      = "${aws_launch_template.launch_template.id}"
    version = "$Latest"
  }
}

# ECS
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.ecs_cluster_name}"
}

resource "aws_ecs_task_definition" "app" {
  family = "app"

  network_mode = "bridge"

  container_definitions = <<DEFINITION
 [
   {
    "name": "${var.ecs_container_name}",
    "image": "ringleai/mt-cicd:v1",
    "cpu": 128,
    "memory": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "ecs_service" {
  # make sure load_balancer's target_group have an associated load balancer
  depends_on = ["aws_lb.elb"]

  name            = "test_service"
  cluster         = "${aws_ecs_cluster.ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.app.arn}"

  launch_type   = "EC2"
  desired_count = 1

  load_balancer {
    target_group_arn = "${aws_lb_target_group.target_group.arn}"
    container_name = "${var.ecs_container_name}"      # same with container name in "aws_ecs_task_definition"
    container_port = 8080
  }
}


output "api-gateway-curl" {
  value = "${aws_api_gateway_deployment.mt_cicd_gateway_deployment.invoke_url}"
}


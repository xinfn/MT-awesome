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
    container_name   = "${var.ecs_container_name}"               # same with container name in "aws_ecs_task_definition"
    container_port   = 8080
  }
}

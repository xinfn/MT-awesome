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

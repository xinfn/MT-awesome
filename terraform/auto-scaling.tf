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

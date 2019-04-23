variable "aws_region" {
  default = "cn-northwest-1"
}

variable "vpc_id" {
  default = "vpc-61833108"
}

variable "sub_net" {
  default = "subnet-b6af66cd"
}

variable "elb_sub_nets" {
  type = "list"
}

variable "amzn2_ami_ecs_image_id" {
  default = "ami-0de54d750becbdaa1" # amzn2-ami-ecs-hvm-2.0.20190402-x86_64-ebs
}

variable "key_name" {
  default = "devops_node_key_pair"
}

variable "elb_name" {
  default = "MT-CICD-ALB-Internet"
}

variable "elb_security_group" {
  default = "sg-0e9bb1e4d3acbe470"
}

variable "elb_target_group" {
  default = "MT-CICD-001-Internet-TargetGroup"
}

variable "ec2_security_group" {
  default = "sg-0e9bb1e4d3acbe470"
}

variable "ecs_cluster_name" {
  default = "mt-cicd-cluster"
}

variable "ecs_container_name" {
  default = "mt-app"
}

variable "ecs_container_user_data_base64" {
  # "#!/bin/bash\necho ECS_CLUSTER=mt-cicd-cluster > /etc/ecs/ecs.config"
  default = "IyEvYmluL2Jhc2gKZWNobyBFQ1NfQ0xVU1RFUj1tdC1jaWNkLWNsdXN0ZXIgPiAvZXRjL2Vjcy9lY3MuY29uZmlnCgo="
}

variable "ecs_instance_role_arn" {
  default = "arn:aws-cn:iam::596703564741:instance-profile/ecsInstanceRole"
}

variable "api_gateway_name" {
  default = "MT-CICD1"
}

variable "api_gateway_stage_name" {
  default = "test"
}

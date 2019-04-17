#!/bin/bash

BASEDIR="$(cd "$(dirname "$0")" && pwd)"
BID=$1

REGION=cn-northwest-1
VPC=vpc-61833108
EC2_SUB_NET="subnet-b6af66cd"
ELB_SUB_NETS="subnet-b6af66cd subnet-5544f03c"
IMAGE_ID="ami-0dd1edad280d16cf3"
USER_DATA=file://$BASEDIR/user-data.txt
ELB=MT-CICD-$BID-ELB-Internet
TARGET_GROUP=MT-CICD-$BID-Internet-TargetGroup
EC2_SECURITY_GROUP=sg-0e9bb1e4d3acbe470
ELB_SECURITY_GROUP=sg-0e9bb1e4d3acbe470

# create EC2 instance and save instance id to aws-instance-ids.txt
if EC2_ID=$(aws --region $REGION ec2 run-instances --instance-type t2.micro --image-id $IMAGE_ID \
	--key-name devops_node_key_pair --security-group-ids $EC2_SECURITY_GROUP \
	--subnet-id $EC2_SUB_NET --associate-public-ip-address --instance-initiated-shutdown-behavior terminate \
	--query "Instances[0].InstanceId" --output text --user-data "${USER_DATA}"); then
	echo $EC2_ID > $BASEDIR/aws-instance-ids.txt
	echo "EC2 starting"
	aws --region $REGION ec2 wait instance-running --instance-ids $EC2_ID
	echo "EC2 started"
else
	echo "EC2 create failed"
	exit 1
fi

# create ELB
if OUT=$(aws --region $REGION elbv2 create-load-balancer --type application --scheme internet-facing \
	--name $ELB --subnets $ELB_SUB_NETS --security-groups $ELB_SECURITY_GROUP \
	--query "LoadBalancers[0].[LoadBalancerArn, DNSName]" --output text); then
	echo "ELB created"
	ELB_ARN=`echo $OUT | cut -d ' ' -f 1`
	ELB_DNS=`echo $OUT | cut -d ' ' -f 2`
else
	echo "ELB create failed"
	exit 2
fi

# create target group
if TARGET_GROUP_ARN=$(aws --region $REGION elbv2 create-target-group --name $TARGET_GROUP --protocol HTTP --port 8080 \
	--vpc-id $VPC --query "TargetGroups[0].TargetGroupArn" --output text); then
	echo "Target group created"
else
	echo "Target group create failed"
	exit 3
fi

# register targets
aws --region $REGION elbv2 register-targets --target-group-arn $TARGET_GROUP_ARN --targets Id=$EC2_ID \
	&& echo "Target registered" \
	|| (echo "Target register failed" && exit 4)

# create listener
aws --region $REGION elbv2 create-listener --load-balancer-arn $ELB_ARN --protocol HTTP --port 80 \
	--default-actions Type=forward,TargetGroupArn=$TARGET_GROUP_ARN > /dev/null \
	&& echo "Listener created" \
	|| (echo "Listener create failed" && exit 5)

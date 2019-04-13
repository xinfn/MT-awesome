#!/bin/bash

BASEDIR="$(cd "$(dirname "$0")" && pwd)"

IMAGEID="ami-0dd1edad280d16cf3"
USERDATA=file://$BASEDIR/user-data.txt

# create EC2 instance and save instance id to aws-instance-ids.txt
aws --region cn-northwest-1 ec2 run-instances --instance-type t2.micro --image-id $IMAGEID --key-name devops_node_key_pair --security-group-ids sg-0e9bb1e4d3acbe470 --subnet-id subnet-b6af66cd --associate-public-ip-address --query "Instances[0].InstanceId" --user-data "${USERDATA}" > $BASEDIR/aws-instance-ids.txt && echo "Instances starting" && cat $BASEDIR/aws-instance-ids.txt | xargs aws --region cn-northwest-1 ec2 wait instance-running --instance-ids && echo "Instances started"

#!/bin/bash

BASEDIR="$(cd "$(dirname "$0")" && pwd)"

# destroy EC2 instances
cat $BASEDIR/aws-instance-ids.txt | xargs aws --region cn-northwest-1 ec2 terminate-instances --instance-ids && echo "Terminating instances" && cat $BASEDIR/aws-instance-ids.txt | xargs aws --region cn-northwest-1 ec2 wait instance-terminated --instance-ids && echo "Instances terminated"

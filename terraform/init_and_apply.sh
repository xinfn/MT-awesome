#!/bin/bash

ENV=dev
BUILD_ID=$1

echo "ENV=${ENV} BUILD_ID=${BUILD_ID}" >> log.txt

exit

terraform init -backend-config="key=infrastructure/$ENV/mt-cicd.tfstate" -plugin-dir=/home/ubuntu/.terraform.d/plugin-cache/linux_amd64/ >> log.txt 2>&1

terraform apply -auto-approve -var 'api_gataway_stage_name=${BUILD_ID}' >> log.txt 2>&1

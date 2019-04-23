#!/bin/bash

ENV=dev
BUILD_ID=$1

echo "ENV=${ENV} BUILD_ID=${BUILD_ID}" >> log.txt

terraform init -backend-config="key=infrastructure/$ENV/mt-cicd.tfstate" -plugin-dir=/home/ubuntu/.terraform.d/plugin-cache/linux_amd64/ >> log.txt 2>&1

API_GATEWAY_STAGE_NAME_VAR_STRING="api_gateway_stage_name=b$BUILD_ID"

terraform apply -auto-approve -var $API_GATEWAY_STAGE_NAME_VAR_STRING >> log.txt 2>&1

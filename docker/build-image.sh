#!/bin/bash

# run from project root dir
docker build -t ringleai/mt-cicd:v1 -f Dockerfile .

# push to docker hub
docker push ringleai/mt-cicd:v1

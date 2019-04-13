#!/bin/bash

# run from project root dir
docker build -t ringleai/mt-cicd -f src/docker/Dockerfile.build .

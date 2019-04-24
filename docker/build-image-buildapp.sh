#!/bin/bash

# run from project root dir
# build a docker image to build project
docker build -t ringleai/mt-build:v1 -f Dockerfile-buildapp .

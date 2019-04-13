#!/bin/bash

BASEDIR=$1

docker run --rm --user "`id -u $USER`:`id -g $USER`" -e XDG_CACHE_HOME=/tmp/.cache -v /home/ubuntu/gopath:/home/ubuntu/gopath -v $BASEDIR:/tmp/MT-awesome -w /tmp/MT-awesome golang:1.11 ./src/server/build.sh


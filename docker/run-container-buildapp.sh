#!/bin/bash

BASEDIR="$(cd "$(dirname "$0")/../" && pwd)"

SRC_PATH=$BASEDIR/src

echo $SRC_PATH

docker run -v ${SRC_PATH}:/go/src ringleai/mt-build:v1

cp $SRC_PATH/server/bin/mt-server .

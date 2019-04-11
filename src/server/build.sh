#!/bin/bash

BASEDIR="$(cd "$(dirname "$0")" && pwd)"
cd $BASEDIR

export GOPATH=$BASEDIR/../../gopath:$BASEDIR/../..
go build -o bin/mt-server main.go
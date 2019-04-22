#!/bin/bash

# create account 'account1'
curl -v -X POST "http://127.0.0.1:8080/account?name=account1&password=123456"

# get account 'account1'
curl -v "http://127.0.0.1:8080/account?name=account1"

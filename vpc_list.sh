#!/bin/bash

NAME=''
PASSWD=''

AUTH_PARAMS='{
  "auth": {
    "identity": {
      "methods": [
        "password"
      ],
      "password": {
        "user": {
          "name": '"\"$NAME\""',
          "password": '"\"$PASSWD\""',
          "domain": {
            "name": '"\"$NAME\""'
          }
        }
      }
    },
   "scope": {
      "project": {
        "name": "cn-north-1"
      }
    }
  }
}'

TOKEN=`curl -i -X POST   https://iam.cn-north-1.myhwclouds.com/v3/auth/tokens  -H 'content-type: application/json'   -d "$AUTH_PARAMS" | grep "X-Subject-Token"| awk '{print$2}'`
PROJECT_ID=`curl -X POST   https://iam.cn-north-1.myhwclouds.com/v3/auth/tokens  -H 'content-type: application/json'   -d "$AUTH_PARAMS"| python -mjson.tool| grep -A 3 project| grep id|awk -F "\"" '{print $4}'`


curl -i -X GET https://vpc.cn-north-1.myhwclouds.com/v1/${PROJECT_ID}/vpcs -H "X-Auth-Token:${TOKEN}"

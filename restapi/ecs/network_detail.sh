#!/bin/bash

HEC_USER_NAME=''
HEC_USER_PASSWD=''

SERVER_ID='42602154-57aa-4843-8729-6c98a5eb690a'


# Region&Endpoints, 
# 具体定义请参考:http://developer.hwclouds.com/endpoint.html
HEC_REGION='cn-north-1'
HEC_IAM_ENDPOINT='https://iam.cn-north-1.myhwclouds.com'
HEC_ECS_ENDPOINT='https://ecs.cn-north-1.myhwclouds.com'
HEC_VPC_ENDPOINT='https://ecs.cn-north-1.myhwclouds.com'

AUTH_PARAMS='{
  "auth": {
    "identity": {
      "methods": [
        "password"
      ],
      "password": {
        "user": {
          "name": '"\"$HEC_USER_NAME\""',
          "password": '"\"$HEC_USER_PASSWD\""',
          "domain": {
            "name": '"\"$HEC_USER_NAME\""'
          }
        }
      }
    },
   "scope": {
      "project": {
        "name": '"\"$HEC_REGION\""'
      }
    }
  }
}'

curl -i -X POST ${HEC_IAM_ENDPOINT}/v3/auth/tokens -H 'content-type: application/json' -d "$AUTH_PARAMS" > /tmp/hec_auth_res && {
    TOKEN=`cat /tmp/hec_auth_res | grep "X-Subject-Token"| awk '{print$2}'`
   

    PROJECT_ID=`tail -n 1 /tmp/hec_auth_res|python -c 'import json,sys;print json.load(sys.stdin)["token"]["project"]["id"]'`
    

    curl -s -X GET ${HEC_ECS_ENDPOINT}/v2/${PROJECT_ID}/servers/${SERVER_ID}/ips -H "X-Auth-Token:${TOKEN}" | python -mjson.tool
}



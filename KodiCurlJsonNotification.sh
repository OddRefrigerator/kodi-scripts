#!/bin/bash

#kodi URL and creds
UserPassword='kodi:password'
hostKodi=http://192.168.2.79:8181/jsonrpc

GenerateJsonData()
{
  cat <<EOF
{
   "id":1,
   "jsonrpc":"2.0",
   "method":"GUI.ShowNotification",
   "params":{
     "title":"test1",
     "message":"Test message using curl and json"
    }
}
EOF
}

curl -v -X POST \
-H "Content-Type:application/json" \
-d "$(GenerateJsonData)" \
-u $UserPassword $Host

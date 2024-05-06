#!/bin/bash

#kodi URL and creds
UserPassword='kodi:password'
hostKodi=http://192.168.2.79:8181/jsonrpc

ExportLibrary()
{
  cat <<EOF
{
    "jsonrpc": "2.0",
    "method": "VideoLibrary.Export",
    "params": {
        "options": {
            "overwrite": true,
            "actorthumbs": false,
            "images": false
        }
    },
    "id": 1
}
EOF
}

jsonReq=$(ExportLibrary)
curl -X POST -H 'Content-Type:application/json' $hostKodi -u $UserPassword -d "$jsonReq"



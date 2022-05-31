#!/bin/sh

#kodi URL and creds
UserPassword='kodi:password'
hostKodi=http://192.168.1.6:8080/jsonrpc

ExportLibrary()
{
  cat <<EOF
{
    "jsonrpc": "2.0",
    "method": "VideoLibrary.Export",
    "params": {
        "options": {
            "overwrite": true,
            "actorthumbs": true,
            "images": true
        }
    },
    "id": 1
}
EOF
}

jsonReq=$(ExportLibrary)
curl -X POST -H 'Content-Type:application/json' $hostKodi -u $UserPassword -d "$jsonReq"



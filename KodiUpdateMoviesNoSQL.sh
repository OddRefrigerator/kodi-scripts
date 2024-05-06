#!/bin/bash

#kodi URL and creds
UserPassword='kodi:password'
hostKodi=http://192.168.2.79:8181/jsonrpc
LowerInt=270

GenerateMovieJsonData()
{
  cat <<EOF
{
   "id":1,
   "jsonrpc":"2.0",
   "method":"VideoLibrary.RefreshMovie",
   "params":{
     "movieid": $LowerInt,
     "ignorenfo": true
    }
}
EOF
}

while [ $LowerInt -le 350 ]
  do
    jsonReq=$(GenerateMovieJsonData $LowerInt)
    echo "Updating movie record" $LowerInt
    echo " "
    curl -X POST -H 'Content-Type:application/json' $hostKodi -u $UserPassword -d "$jsonReq"
    echo " "
    ((LowerInt=LowerInt+1))
done


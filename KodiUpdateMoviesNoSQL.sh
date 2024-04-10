#!/bin/sh
#kodi URL and creds
UserPassword='kodi:Password'
hostKodi=http://192.168.2.79:8181/jsonrpc
LowerInt=400

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

while [ $LowerInt -le 600 ]
  do
    jsonReq=$(GenerateMovieJsonData $LowerInt)
    echo "Updating movie record" $LowerInt
    echo " "
    curl -X POST -H 'Content-Type:application/json' $hostKodi -u $UserPassword -d "$jsonReq"
    echo " "
    ((LowerInt=LowerInt+1))
done


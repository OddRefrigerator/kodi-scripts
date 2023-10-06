#!/bin/sh
#kodi URL and creds
UserPassword='kodi:TheFlyingFish'
hostKodi=http://192.168.0.104:8181/jsonrpc
LowerInt=1

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

while [ $LowerInt -le 100 ]
  do
    jsonReq=$(GenerateMovieJsonData $LowerInt)
    curl -vvv -X POST -H 'Content-Type:application/json' $hostKodi -u $UserPassword -d "$jsonReq"
    echo " "
    echo "Updating movie record" $LowerInt
    echo " "
    ((LowerInt=LowerInt+1))
done


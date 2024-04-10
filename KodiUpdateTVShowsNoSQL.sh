#!/bin/sh
#kodi URL and creds
UserPassword='kodi:Password'
hostKodi=http://192.168.2.79:8181/jsonrpc
LowerInt=230

GenerateTVJsonData()
{
  cat <<EOF
{
   "id":1,
   "jsonrpc":"2.0",
   "method":"VideoLibrary.RefreshTVShow",
   "params":{
     "tvshowid": $LowerInt,
     "ignorenfo": true,
     "refreshepisodes": true
    }
}
EOF
}

while [ $LowerInt -le 350 ]
  do
    jsonReq=$(GenerateTVJsonData $LowerInt)
    echo "Updating TV record" $LowerInt
    echo " "
    curl -X POST -H 'Content-Type:application/json' $hostKodi -u $UserPassword -d "$jsonReq"
    echo " "
    ((LowerInt=LowerInt+1))
done

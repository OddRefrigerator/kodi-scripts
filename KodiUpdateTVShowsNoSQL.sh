#!/bin/sh
#kodi URL and creds
UserPassword='kodi:TheFlyingFish'
hostKodi=http://192.168.0.104:8181/jsonrpc
LowerInt=40

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

while [ $LowerInt -le 100 ]
  do
    jsonReq=$(GenerateTVJsonData $LowerInt)
    curl -vvv -X POST -H 'Content-Type:application/json' $hostKodi -u $UserPassword -d "$jsonReq"
    echo " "
    echo "Updating TV record" $LowerInt
    echo " "
    ((LowerInt=LowerInt+1))
done


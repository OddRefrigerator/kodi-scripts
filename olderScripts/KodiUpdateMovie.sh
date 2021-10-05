#!/bin/sh

UserPassword="kodi:TheFlyingFish"
Host=http://rpi4.home.local:8080/jsonrpc
movieidParam=$1

GenerateJsonData()
{
  cat <<EOF
{
   "id":1,
   "jsonrpc":"2.0",
   "method":"VideoLibrary.RefreshMovie",
   "params":{
     "movieid": $movieidParam,
     "ignorenfo": true
    }
}
EOF
}

curl -v -X POST \
-H "Content-Type:application/json" \
-d "$(GenerateJsonData)" \
-u $UserPassword $Host

echo "\n"
echo "First arg. is" $1

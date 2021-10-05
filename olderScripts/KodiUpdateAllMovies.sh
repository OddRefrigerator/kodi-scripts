#!/bin/sh

UserPassword="kodi:TheFlyingFish"
Host=http://rpi4:8080/jsonrpc

x=1554

while [ $x -le 1558 ]
do
  x=$(( $x + 1 ))
  echo " "
  echo "Value of $x used in request"
  echo " "

GenerateJsonData()
{
  cat <<EOF
{
   "id":1,
   "jsonrpc":"2.0",
   "method":"VideoLibrary.RefreshMovie",
   "params":{
     "movieid": $x,
     "ignorenfo": true
    }
}
EOF
}

echo "$(GenerateJsonData)"

curl -v -X POST \
-H "Content-Type:application/json" \
-d "$(GenerateJsonData)" \
-u $UserPassword $Host

done


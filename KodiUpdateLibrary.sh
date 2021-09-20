#!/bin/sh

# 1 = TV shows / 2 = Movies
content=2

#Database creds
user=kodi
password=TheFlyingFish
hostMysql=192.168.0.107
database=MyVideos116

#kodi URL and creds
UserPassword='kodi:TheFlyingFish'
hostKodi=http://rpi4:8080/jsonrpc

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

if [ $content = 1 ]
 then
  LowerInt=$(echo "SELECT idshow FROM tvshow ORDER BY idshow ASC limit 1;" | mysql -u$user -p$password -h$hostMysql -D$database -s )
  UpperInt=$(echo "SELECT idshow FROM tvshow ORDER BY idshow DESC limit 1;" | mysql -u$user -p$password -h$hostMysql -D$database -s )
  while [ $LowerInt -le $UpperInt ]
  do
    jsonReq=$(GenerateTVJsonData $LowerInt)
    curl -v POST -H 'Content-Type:application/json' -u $UserPassword $hostKodi -d "$jsonReq"
    echo " "
    echo "Updating TV record" $LowerInt "of" $UpperInt
    echo " "
    ((LowerInt=LowerInt+1))
  done
 else
  LowerInt=$(echo "SELECT idmovie FROM movie ORDER BY idmovie ASC limit 1;" | mysql -u$user -p$password -h$hostMysql -D$database -s )
  UpperInt=$(echo "SELECT idmovie FROM movie ORDER BY idmovie DESC limit 1;" | mysql -u$user -p$password -h$hostMysql -D$database -s )
  while [ $LowerInt -le $UpperInt ]
  do
    jsonReq=$(GenerateMovieJsonData $LowerInt)
    curl -v POST -H 'Content-Type:application/json' -u $UserPassword $hostKodi -d "$jsonReq"
    echo " "
    echo "Updating movie record" $LowerInt "of" $UpperInt
    echo " "
    ((LowerInt=LowerInt+1))
  done
fi

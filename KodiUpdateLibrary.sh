#!/bin/sh

if [[ $1 = "" ]]
 then
 echo "1 to refresh TV series." 
 echo "2 to refresh Movies." 
 echo "3 to update the library."
 exit
fi
content=$1

#Database creds
user=kodi
password=TheFlyingFish
hostMysql=192.168.0.107
database=MyVideos116

#kodi URL and creds
UserPassword='kodi:password'
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

GenerateLibraryUpdateJsonData()
{
  cat <<EOF
{
   "id":1,
   "jsonrpc":"2.0",
   "method":"VideoLibrary.Scan",
   "params":{
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
    curl -X POST -H 'Content-Type:application/json' $hostKodi -u $UserPassword -d "$jsonReq"
    echo " "
    echo "Updating TV record" $LowerInt "of" $UpperInt
    echo " "
    ((LowerInt=LowerInt+1))
  done
elif [ $content = 2 ]
 then 
  LowerInt=$(echo "SELECT idmovie FROM movie ORDER BY idmovie ASC limit 1;" | mysql -u$user -p$password -h$hostMysql -D$database -s )
  UpperInt=$(echo "SELECT idmovie FROM movie ORDER BY idmovie DESC limit 1;" | mysql -u$user -p$password -h$hostMysql -D$database -s )
  while [ $LowerInt -le $UpperInt ]
  do
    jsonReq=$(GenerateMovieJsonData $LowerInt)
    curl -X POST -H 'Content-Type:application/json' $hostKodi -u $UserPassword -d "$jsonReq"
    echo " "
    echo "Updating movie record" $LowerInt "of" $UpperInt
    echo " "
    ((LowerInt=LowerInt+1))
  done
else
    jsonReq=$(GenerateLibraryUpdateJsonData)
    curl -X POST -H 'Content-Type:application/json' $hostKodi -u $UserPassword -d "$jsonReq"
    echo " "
    echo "Updating library"
    echo " "
fi

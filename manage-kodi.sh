#!/bin/sh

#kodi URL and creds
UserPassword='kodi:TheFlyingFish'
hostKodi=http://192.168.1.101:8080/jsonrpc

ExportLibraryJsonData()
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

UpdateLibraryJsonData()
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

UpdateMovieJsonData()
{
  cat <<EOF
{
   "id":1,
   "jsonrpc":"2.0",
   "method":"VideoLibrary.RefreshMovie",
   "params":{
     "movieid": $movieid,
     "ignorenfo": true
    }
}
EOF
}

UpdateTVJsonData()
{
  cat <<EOF
{
   "id":1,
   "jsonrpc":"2.0",
   "method":"VideoLibrary.RefreshTVShow",
   "params":{
     "tvshowid": $tvshowid,
     "ignorenfo": true,
     "refreshepisodes": true
    }
}
EOF
}

GetMoviesJsonData()
{
  cat <<EOF
{
   "jsonrpc": "2.0", 
   "method":"VideoLibrary.GetMovies", 
   "params":{ 
     "sort":{ 
       "order": "ascending", 
       "method": "label",
       "ignorearticle": true 
       } 
    },
   "id": "libMovies"
}
EOF
}


GetTVShowsJsonData()
{
  cat <<EOF
{
   "jsonrpc": "2.0", 
   "method":"VideoLibrary.GetTVShows", 
   "params":{ 
     "sort":{ 
       "order": "ascending", 
       "method": "label",
       "ignorearticle": true 
       } 
    },
   "id": "libMovies"
}
EOF
}



#BASH colours
nc='\033[0m'
purple='\033[0;35m'
blue='\033[0;34m'
BWhite='\033[1;37m'
BBlue='\033[1;34m'

echo "==================================="
echo -e "${BBlue}Manage Kodi via soap with JSON${nc}"
echo "==================================="
echo "1 to export the library."
echo "2 to update the library."
echo "3 get a list of movies including ID"
echo "4 get a list of TV series including ID"
echo "5 to refresh a TV series by ID." 
echo -e "6 to refresh a movie by ID.${BWhite}"

read -p "choice: " choice

echo -e "${nc}"
case $choice in
  1)
    jsonReq="$(ExportLibraryJsonData)"
    echo "Exporting the library to disk"
    ;;
  2)
    jsonReq=$(UpdateLibraryJsonData)
    echo "Updating the library"
    ;;
  3)
    jsonReq=$(GetMoviesJsonData)
    echo "Printing movies"
    ;;
  4)
    jsonReq=$(GetTVShowsJsonData)
    echo "Printing TV series"
    ;;
  5)
    read -p "tvshowid: " tvshowid
    jsonReq=$(UpdateTVJsonData)
    echo "Updating TV series"
    ;;
  6)
    read -p "movieid: " movieid
    jsonReq=$(UpdateMovieJsonData)
    echo "Updating movie"
    ;;  
esac

curl -X POST -H 'Content-Type:application/json' $hostKodi -u $UserPassword -d "$jsonReq"
echo ""
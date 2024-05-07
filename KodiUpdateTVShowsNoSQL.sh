#!/bin/bash

# Function to build the Kodi connection URL
kodi_connect_url() {
  local protocol="http"  # You can modify this if needed (e.g., https)
  local ip="$1"
  local port="$2"
  echo "$protocol://${ip}:${port}/jsonrpc"
}

# Function to build the Kodi authorization header
kodi_auth_header() {
  local username="$1"
  local password="$2"
  local encoded_credentials=$(echo -n "$username:$password" | base64)
  echo "Authorization: Basic $encoded_credentials"
}

# Process command-line arguments
while getopts ":u:p:i:P:" opt; do
  case $opt in
    u) kodi_username="$OPTARG" ;;
    p) kodi_password="$OPTARG" ;;
    i) kodi_ip="$OPTARG" ;;
    P) kodi_port="$OPTARG" ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done

# Remove processed options from $@
shift $((OPTIND-1))

# Check if required arguments are provided
if [[ -z "$kodi_username" || -z "$kodi_password" || -z "$kodi_ip" || -z "$kodi_port" ]]; then
  echo "Error: Missing required arguments. Please provide -u username, -p password, -i IP address, and -P port."
  exit 1
fi

kodi_url=$(kodi_connect_url "$kodi_ip" "$kodi_port")
auth_header=$(kodi_auth_header "$kodi_username" "$kodi_password")

# Function to build the JSON request GetTVShows
GetTVShows() {
  echo '{"jsonrpc": "2.0", "method": "VideoLibrary.GetTVShows", "params": {}, "id": 1}'
}

# Function to build the JSON request RefreshTVShow
RefreshTVShow() {
  local show_id="$1"
  echo '{"jsonrpc": "2.0", "method": "VideoLibrary.RefreshTVShow", "params": {"tvshowid": '$show_id', "ignorenfo": true, "refreshepisodes": true}, "id": 1}'
}

# Get the JSON request
json_req=$(GetTVShows)

# Send request using curl and capture the response
response=$(curl -X POST -s -H 'Content-Type: application/json' -H "$auth_header" "$kodi_url" -d "$json_req")

# Check if curl was successful (exit code 0 indicates success)
if [ $? -ne 0 ]; then
  echo "Error: Failed to retrieve movies from Kodi."
  exit 1
fi

# Parse the response using jq
# Extract movie IDs using error handling (assuming jq might fail)
Show_ids=$(echo "$response" | jq -r '.result.tvshows[].tvshowid' || true)
if [ $? -eq 0 ]; then
  echo "Show IDs retrieved successfully."
else
  echo "Error: Unable to parse show IDs from response."
fi

# Declare an empty array to store movie IDs
declare -a show_id_array

# Loop through each movie ID and add it to the array
for show_id in $Show_ids; do
  show_id_array+=("$show_id")
done

# Print the lower and upper IDs
echo "The lower ID is: ${show_id_array[0]}"
echo "The upper ID is: ${show_id_array[${#show_id_array[@]} - 1]}"
echo "Refreshing TV shows"

for show_id in "${show_id_array[@]}" 
do
    json_req=$(RefreshTVShow $show_id)
    echo "Refreshing show record" $show_id
    echo $json_req
    curl -X POST -s -H 'Content-Type: application/json' -H "$auth_header" "$kodi_url" -d "$json_req"
    echo " "
    echo " "
done
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

ShowNotification()
{
  echo '{"jsonrpc": "2.0", "method": "GUI.ShowNotification", "params":{ "title": "test1", "message": "Test message using curl and json"}, "id": 1}'
}

# Get the JSON request
json_req=$(ShowNotification)

# Send request using curl and capture the response
response=$(curl -X POST -s -H 'Content-Type: application/json' -H "$auth_header" "$kodi_url" -d "$json_req")

# Check if curl was successful (exit code 0 indicates success)
if [ $? -ne 0 ]; then
  echo "Error: Failed to retrieve movies from Kodi."
  exit 1
fi

echo $response

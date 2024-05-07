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
while getopts ":u:p:i:P:t:m:" opt; do
  case $opt in
    u) kodi_user_name="$OPTARG" ;;
    p) kodi_password="$OPTARG" ;;
    i) kodi_ip="$OPTARG" ;;
    P) kodi_port="$OPTARG" ;;
    m) kodi_message="$OPTARG" ;;
    t) kodi_title="$OPTARG" ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done

# Remove processed options from $@
shift $((OPTIND-1))

# Check for required arguments
if [[ -z "$kodi_user_name" || -z "$kodi_password" || -z "$kodi_ip" || -z "$kodi_port" || -z "$kodi_title" || -z "$kodi_message" ]]; then
  echo "Error: Missing required arguments. Please provide -u username, -p password, -i IP address, -P port, -m message -t title message."
  exit 1
fi

kodi_url=$(kodi_connect_url "$kodi_ip" "$kodi_port")
auth_header=$(kodi_auth_header "$kodi_user_name" "$kodi_password")

# Function to build the JSON request (with optional arguments)
ShowNotification() {
  local title="$1"
  local message="$2"
  local displaytime="${3:-5000}"  # Default display time (optional)
  local image="${4:-}"            # Empty image path (optional)

  # Validate optional arguments (optional - add checks as needed)
  # if [[ ! -f "$image" ]]; then  # Example check for image existence
  #   echo "Warning: Invalid image path provided."
  # fi

  echo '{"jsonrpc": "2.0", "method": "GUI.ShowNotification", "params": { "title": "'"$title"'", "message": "'"$message"'", "displaytime": '$displaytime', "image": "'"$image"'" }, "id": 1}'
}

# Get the JSON request (call the function)
json_req=$(ShowNotification "$kodi_title" "$kodi_message")

# Send request using curl and capture the response
response=$(curl -X POST -s -H 'Content-Type: application/json' -H "$auth_header" "$kodi_url" -d "$json_req")

# Check if curl was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to show notification on Kodi."
  exit 1
fi

echo "Notification sent successfully."

#!/bin/bash

# Kodi credentials
kodi_username="kodi"
kodi_password="DogRunFast"
kodi_UserPassword="$kodi_username:$kodi_password"
kodi_host="http://192.168.2.79:8181/jsonrpc"

# Function to build the JSON request
GetMovies() {
  echo '{"jsonrpc": "2.0", "method": "VideoLibrary.GetMovies", "params": {}, "id": 1}'
}

# Get the JSON request
json_req=$(GetMovies)

# Send request using curl and capture the response
response=$(curl -X POST -s -H 'Content-Type: application/json' "$kodi_host" -u "$kodi_UserPassword" -d "$json_req")

# Check if curl was successful (exit code 0 indicates success)
if [ $? -ne 0 ]; then
  echo "Error: Failed to retrieve movies from Kodi."
  exit 1
fi

# Parse the response using jq
# Extract movie IDs using error handling (assuming jq might fail)
movie_ids=$(echo "$response" | jq -r '.result.movies[].movieid' || true)
if [ $? -eq 0 ]; then
  echo "Movie IDs retrieved successfully."
else
  echo "Error: Unable to parse movie IDs from response."
fi

# Declare an empty array to store movie IDs
declare -a movie_id_array

# Loop through each movie ID and add it to the array
for movie_id in $movie_ids; do
  movie_id_array+=("$movie_id")
done

# Print the lower and upper IDs
echo "The lower ID is: ${movie_id_array[0]}"
echo "The upper ID is: ${movie_id_array[${#movie_id_array[@]} - 1]}"

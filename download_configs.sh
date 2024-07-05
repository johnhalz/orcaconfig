#!/bin/bash

# Define the GitHub repository details
GITHUB_USERNAME="johnhalz"
GITHUB_REPO="orcaconfig"
GITHUB_BRANCH="main"

# Define the local destination paths
LOCAL_BASE_PATH="$HOME/Library/Application Support/OrcaSlicer/user/default"
FILAMENT_PATH="$LOCAL_BASE_PATH/filament"
MACHINE_PATH="$LOCAL_BASE_PATH/machine"
PROCESS_PATH="$LOCAL_BASE_PATH/process"

# Create directories if they do not exist
mkdir -p "$FILAMENT_PATH" "$MACHINE_PATH" "$PROCESS_PATH"

# Function to download files from GitHub and save them to the local paths
download_files() {
    local folder=$1
    local dest_path=$2
    curl -s "https://api.github.com/repos/$GITHUB_USERNAME/$GITHUB_REPO/contents/$folder?ref=$GITHUB_BRANCH" | \
    awk -F'"' '/"download_url":/ {print $4}' | \
    while read -r url; do
        file_name=$(basename "$url")
        curl -s "$url" -o "$dest_path/$file_name"
        mv "$dest_path/$file_name" "$dest_path/$(echo $file_name | sed 's/%20/ /g')"
    done
}

# Download files for each folder
download_files "filament" "$FILAMENT_PATH"
download_files "machine" "$MACHINE_PATH"
download_files "process" "$PROCESS_PATH"

echo "Files downloaded successfully."
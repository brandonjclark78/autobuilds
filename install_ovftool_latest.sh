#!/bin/bash

#https://mikebosland.com/installing-ovftool/ < thanks mike
#  It appears ^ that linux (just Ubuntu?) needs some help in getting the ovftool working

#setting URL of latest ovftool (.zip version for linux)
download_url=$(curl -sSL -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" "https://developer.vmware.com/web/tool/ovf-tool/#latest" | grep -oP 'href="\K[^"]*(ovftool.*\-lin.x86_64.zip)[^"]*')

download_directory="/shared" #location to download to
filename=$(basename "$download_url")
zip_path="$download_directory/$filename"

#Downloading file, overwriting if neccessary
wget -O "$download_url" -P "$download_directory"

echo "Downloaded file: $filename"

# Extract the ZIP file, overwrite if neccessary
sudo unzip -o "$zip_path" -d /usr/bin/

echo "Extracted contents to: $download_directory"

#make files executable
sudo chmod +x /usr/bin/ovftool/ovftool.bin
sudo chmod +x /usr/bin/ovftool/ovftool


# Set the alias definition
alias_definition='alias ovftool="/usr/bin/ovftool/ovftool"'

# Create a file in /etc/profile.d/ with the alias definition
alias_file="/etc/profile.d/ovftool.sh"

# Check if the file does not exist before adding the alias definition
if [ ! -e "$alias_file" ]; then
    echo "$alias_definition" | sudo tee "$alias_file" > /dev/null
fi


# Make the script executable
sudo chmod +x "$alias_file"

# Source the system-wide profile to apply changes immediately
source /etc/profile
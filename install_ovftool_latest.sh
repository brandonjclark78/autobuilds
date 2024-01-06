#!/bin/bash

#https://mikebosland.com/installing-ovftool/ < thanks mike
#  It appears ^ that linux (just Ubuntu?) needs some help in getting the ovftool working

#setting URL of latest ovftool (.zip version for linux)
download_url=$(curl -sSL -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" "https://developer.vmware.com/web/tool/ovf-tool/#latest" | grep -oP 'href="\K[^"]*(ovftool.*\-lin.x86_64.zip)[^"]*')

download_directory="/shared" #location to download to
filename=$(basename "$download_url")
zip_path="$download_directory/$filename"

# Check if the file does not exist before downloading
if [ ! -e "$zip_path" ]; then
    clear
    echo "It's not there"
    # Downloading file, overwriting if necessary
    wget "$download_url" -P "$download_directory"
else
    clear
    echo "The file was found, overwriting"
    # Downloading file, overwriting if necessary
    wget -O "$zip_path" "$download_url" -P "$download_directory"
fi



echo "Downloaded file: $filename"

# Extract the ZIP file, overwrite if neccessary
sudo unzip -o "$zip_path" -d /usr/bin/vmware-ovftool

echo "Extracted contents to: usr/bin/vmware-ovftool"

#make files executable
sudo chmod +x /usr/bin/vmware-ovftool/ovftool/ovftool.bin
sudo chmod +x /usr/bin/vmware-ovftool/ovftool/ovftool

#sudo chmod +x /usr/bin/ovftool.bin
#sudo chmod +x /usr/bin/ovftool


# Set the alias definition
alias_definition='alias ovftool="/usr/bin/vmware-ovftool/ovftool/overtool"'

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

#!/bin/bash

folder_path="/usr/bin/vmware-ovftool"

# Check if the folder is not already in the PATH
if ! grep -q "^PATH=.*:$folder_path" /etc/environment; then
    # Add the folder to the PATH
    echo "PATH=\$PATH:$folder_path" | sudo tee -a /etc/environment > /dev/null

    # Apply the changes
    source /etc/environment
    echo "Folder added to the system-wide PATH."
else
    echo "Folder is already in the system-wide PATH."
fi

source /etc/environment

folder_path="/usr/bin/vmware-ovftool/ovftool"

# Check if the folder is not already in the PATH
if ! grep -q "^PATH=.*:$folder_path" /etc/environment; then
    # Add the folder to the PATH
    echo "PATH=\$PATH:$folder_path" | sudo tee -a /etc/environment > /dev/null

    # Apply the changes
    source /etc/environment
    echo "Folder added to the system-wide PATH."
else
    echo "Folder is already in the system-wide PATH."
fi

source /etc/environment
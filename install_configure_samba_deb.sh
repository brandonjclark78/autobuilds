#!/bin/bash

#This shell script is an attempt to provision an open samba share on an Ubuntu (deb) system for local testing only.
#Do NOT put an open share into production, people.

#update default repo and install samba
echo "Updating repos and installing Samba..."
sudo apt-get update && sudo apt-get install -y samba

#enable smb startup
echo "Configuring Samba for service auto-start..."
sudo systemctl enable --now smbd

#create /shared directory at root of filesystem if it doesn't exist
echo "Creating Sambas directory at /shared..."
[[ -d /shared ]] || sudo mkdir /shared


#setting permissions on /shared
echo "Setting permissions on shared..."
sudo chmod -R ugo+w /shared


# Set default ACLs on the /shared directory
echo "Installing package 'acl'"
sudo apt-get update && sudo apt-get install -y acl
echo "Setting default ACL on /shared"
sudo setfacl -d -m u::rwx,g::rwx,o::rwx /shared


#stop samba
echo "Stopping Samba service..."
sudo systemctl stop smbd

#delete smb.conf
#sudo rm /etc/samba/smb.conf



# Content to be added to smb.conf
contentToAdd='
[shared]
  path = /shared
  public = yes
  guest only = yes
  writable = yes
  force create mode = 0666
  force directory mode = 0777
  browseable = yes
'
echo "Here is the content to add to smb.conf: $contentToAdd"

# Check if the content already exists in smb.conf
if ! diff -q <(echo "$contentToAdd") /etc/samba/smb.conf &> /dev/null; then
    # If not, append the content to smb.conf using sudo
    echo "$contentToAdd" | sudo tee -a /etc/samba/smb.conf > /dev/null
    echo "Content added to smb.conf"
else
    # If the content already exists, print a message
    echo "Content already exists in smb.conf"
fi


#start samba
echo "Starting Samba service..."
sudo systemctl restart smbd


printf "Samba configured at: $(date):$(hostname)\n" >> samba_configured.txt

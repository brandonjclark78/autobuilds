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

#stop samba
echo "Stopping Samba service..."
sudo systemctl stop smbd

#delete smb.conf
#sudo rm /etc/samba/smb.conf



#recreate smb.conf with our "open" settings
echo "Appending to smb.conf..." >
sudo bash -c '{
    echo "  [shared]"
    echo "  path = /shared"
    echo "  public = yes"
    echo "  guest only = yes"
    echo "  writable = yes"
    echo "  force create mode = 0666"  
    echo "  force directory mode = 0777"
    echo "  browseable = yes"
} >> /etc/samba/smb.conf'



#start samba
echo "Starting Samba service..."
sudo systemctl start smbd


printf "Samba configured at: $(date):$(hostname)\n" >> samba_configured.txt

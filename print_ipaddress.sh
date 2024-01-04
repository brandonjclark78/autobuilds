#!/bin/bash
green='\e[32m'  # Green text
reset='\e[0m'   # Reset text color to default
ipaddr=$(hostname -I)
hostname=$(hostname)
echo -e "The IP Address of $hostname is: ${green}$ipaddr"

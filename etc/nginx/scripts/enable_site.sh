#!/bin/bash

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Check if the user has provided an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <site-name>"
    exit 1
fi

# Define the site name
SITE_NAME=$1

# Define the paths for available and enabled sites
SITES_AVAILABLE="/etc/nginx/sites-available"
SITES_ENABLED="/etc/nginx/sites-enabled"

# Check if the site configuration file exists in sites-available
if [ ! -f "$SITES_AVAILABLE/$SITE_NAME" ]; then
    echo "The configuration file for the site does not exist: $SITES_AVAILABLE/$SITE_NAME"
    exit 1
fi

# Create the symbolic link
ln -s "$SITES_AVAILABLE/$SITE_NAME" "$SITES_ENABLED/$SITE_NAME"

echo "Symbolic link created for $SITE_NAME"

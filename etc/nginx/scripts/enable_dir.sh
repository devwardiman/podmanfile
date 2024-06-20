#!/bin/bash

# Set permissions group www-data
# Check if the site configuration file exists in sites-available
if [ ! -f "/var/www" ]; then
    echo "The configuration file for the site does not exist: /var/www"
    mkdir -p /var/www
fi

chmod -R 775 /var/www
chown -R root:www-data /var/www

# Check if the site configuration file exists in sites-available
if [ ! -f "/var/volumes" ]; then
    echo "The configuration file for the site does not exist: /var/www"
    mkdir -p /var/volumes
fi

chown -R user:www-data /var/volumes

exit 0
# Use Base Image as multi-stage build
FROM base-perakit:latest as builder

# Use Alpine Linux as the base image
FROM ubuntu:latest

LABEL maintainer devwardiman <devwardiman@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt install -y \ 
    software-properties-common \
    curl \
    unzip \
    gnupg \
    ca-certificates

# Add the Ondřej Surý PPA for PHP
RUN add-apt-repository ppa:ondrej/php

# Nodejs 20.x
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

# Update and upgrade the package manager
RUN apt-get update && apt install -y \
    supervisor \
    nginx

# MariaDB
RUN apt-get install -y mariadb-server mariadb-client

# install php, php-extensions and nodejs
RUN apt-get install -y \
    php8.3 php8.3-cli php8.3-fpm \
    php8.3-curl php8.3-exif php8.3-ffi \
    php8.3-fileinfo php8.3-mysqlnd php8.3-gd \
    php8.3-bz2 php8.3-opcache php8.3-zip \
    php8.3-gmp php8.3-intl php8.3-common \
    php8.3-bcmath php8.3-imagick php8.3-xmlrpc \
    php8.3-readline php8.3-memcached php8.3-redis \
    php8.3-mbstring php8.3-apcu php8.3-xml \
    php8.3-dom php8.3-memcache php8.3-pdo \
    php8.3-pgsql php8.3-shmop php8.3-soap \
    php8.3-sockets php8.3-sqlite3 php8.3-mysqli \
    php8.3-exif php8.3-iconv php8.3-imagick \
    composer nodejs

# Install Yarn globally
RUN npm install --global yarn

COPY --from=builder /app/mariadb/ubuntu.sh /scripts/run.sh

# Create a directory for scripts
RUN mkdir /docker-entrypoint-initdb.d && \
    mkdir /scripts/pre-exec.d && \
    mkdir /scripts/pre-init.d && \
    chmod -R 755 /scripts

# Create a directory for Nginx run and log files
RUN mkdir -p /var/log/supervisor && \
    mkdir -p /run/nginx && \    
    mkdir -p /var/log/nginx && \
    mkdir -p /etc/nginx/sites-available && \
    mkdir -p /etc/nginx/sites-enabled && \
    mkdir -p /var/www/html

# # Add user for rootless container access
RUN adduser -D user && \
    addgroup user www-data

# Set permissions group www-data
RUN chown -R :www-data /var/www && \
    chmod -R 775 /var/www && \
    chown -R user:www-data /var/volumes

# Copy the Nginx configuration file into the container
COPY --from=builder /app/supervisor/ubuntu.conf /etc/supervisord.conf

# create symbolic link for default site available for nginx
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Set up working directory
WORKDIR /var/www

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
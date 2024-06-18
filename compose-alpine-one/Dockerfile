# Use Base Image as multi-stage build
FROM base-perakit:latest as builder

# Use Alpine Linux as the base image
FROM alpine:latest

LABEL maintainer devwardiman <devwardiman@gmail.com>

# Update and upgrade the package manager
RUN apk update && apk upgrade

# install bash, curl and supervisor
RUN apk add --no-cache bash curl supervisor

# Install nginx, nodejs and npm
RUN apk add --no-cache nginx nodejs-current npm

# Install MariaDB
RUN apk add --no-cache mariadb mariadb-client mariadb-server-utils pwgen

# Install php83 and common extensions
RUN apk add --no-cache php83 php83-cli php83-fpm \
    php83-curl php83-fileinfo php83-fileinfo \
    php83-pdo php83-pdo_mysql php83-mbstring \
    php83-tokenizer php83-xml php83-ctype \
    php83-json php83-openssl php83-phar \
    php83-zip php83-gd php83-dom \
    php83-session php83-simplexml php83-sqlite3 \
    php83-intl php83-xmlwriter

# Install Yarn globally
RUN npm install --global yarn

# Install Composer globally
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"
    
# Clean up
RUN rm -f /var/cache/apk/*

COPY --from=builder /app/mariadb/alpine.sh /scripts/run.sh

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

# Add user for rootless container access
RUN adduser -D user && \
    addgroup user www-data

# Set permissions group www-data
RUN chown -R :www-data /var/www/html && \
    chmod -R ugo+rw /var/www/html
# RUN chmod -R g+w /var/www/html

# Copy the Nginx configuration file into the container
COPY --from=builder /app/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /app/supervisor/alpine.conf /etc/supervisord.conf

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
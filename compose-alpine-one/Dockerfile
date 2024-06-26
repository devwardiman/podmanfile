# Use Base Image as multi-stage build
FROM base-perakit:latest as builder

# Use Alpine Linux as the base image
FROM alpine:latest

LABEL maintainer devwardiman <devwardiman@gmail.com>

# Update and upgrade the package manager
RUN apk update && apk upgrade

# Install bash, curl, unzip and supervisor
RUN apk add --no-cache bash curl unzip supervisor

# Add git, openssl and openssh
RUN apk add --no-cache git openssl openssh-client

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
    php83-intl php83-xmlwriter php83-mysqli \
    php83-exif php83-iconv php83-pecl-imagick

# Install Yarn globally
RUN npm install --global yarn

# Install Composer globally
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

# Clean up
RUN rm -f /var/cache/apk/*

# Add scripts
COPY --from=builder /app/mariadb/alpine.sh /scripts/run.sh
COPY --from=builder /app/nginx/scripts/ /run/nginx

# Create a directory for scripts
RUN mkdir /docker-entrypoint-initdb.d && \
    mkdir /scripts/pre-exec.d && \
    mkdir /scripts/pre-init.d && \
    chmod -R 755 /scripts && \
    chmod +x /run/nginx/*.sh

# Create a directory for Nginx run and log files
RUN mkdir -p /var/log/supervisor && \
    mkdir -p /var/log/nginx && \
    mkdir -p /etc/nginx/sites-available && \
    mkdir -p /etc/nginx/sites-enabled

RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Add user for rootless container access
RUN adduser -D user && \
    addgroup user www-data

# Configure PHP-FPM
RUN sed -i 's/;listen.owner = nobody/listen.owner = user/' /etc/php83/php-fpm.d/www.conf \
    && sed -i 's/;listen.group = nobody/listen.group = www-data/' /etc/php83/php-fpm.d/www.conf \
    && sed -i 's/user = nobody/user = user/' /etc/php83/php-fpm.d/www.conf \
    && sed -i 's/group = nobody/group = www-data/' /etc/php83/php-fpm.d/www.conf \
    && sed -i 's/listen = 127.0.0.1:9000/listen = 9000/' /etc/php83/php-fpm.d/www.conf

# Copy the Nginx configuration file into the container
COPY --from=builder /app/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /app/supervisor/alpine.conf /etc/supervisord.conf

ENTRYPOINT ["supervisord", "--configuration", "/etc/supervisord.conf"]
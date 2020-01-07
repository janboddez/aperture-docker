#!/bin/sh
set -e

if [ ! -e /var/www/html/aperture/.env ]; then
    cd /var/www/html

    git clone https://github.com/aaronpk/Aperture.git .

    cd aperture

    composer install

    cp .env.example .env

    chown -R www-data:www-data .

    sed -i "s|APP_URL=http://localhost|APP_URL=${WATCHTOWER_CB:=https\://aperture.example.org}|g" .env
    sed -i "s|WATCHTOWER_URL=https://watchtower.dev|WATCHTOWER_URL=${WATCHTOWER_URL:=https\://watchtower.example.org}|g" .env
    sed -i "s|WATCHTOWER_CB=https://aperture.dev|WATCHTOWER_CB=${WATCHTOWER_CB}|g" .env
    sed -i "s|WATCHTOWER_TOKEN=1234|WATCHTOWER_TOKEN=${WATCHTOWER_TOKEN:=1234}|g" .env

    sed -i "s|IMG_PROXY_URL=https://aperture-proxy.p3k.io/|IMG_PROXY_URL=${IMG_PROXY_URL:=https\://camo.example.org/}|g" .env
    sed -i "s|IMG_PROXY_KEY=1234567890|IMG_PROXY_KEY=${IMG_PROXY_KEY:=1234567890}|g" .env

    sed -i "s|DB_HOST=127.0.0.1|DB_HOST=${MYSQL_HOST:=127.0.0.1}|g" .env
    sed -i "s|DB_PASSWORD=secret|DB_PASSWORD=${MYSQL_PASSWORD:=aperture}|g" .env

    sed -i "s|REDIS_HOST=127.0.0.1|REDIS_HOST=${REDIS_HOST:=127.0.0.1}|g" .env
    sed -i "s|REDIS_PASSWORD=null|REDIS_PASSWORD=${REDIS_PASSWORD:=null}|g" .env
fi

exec "$@"

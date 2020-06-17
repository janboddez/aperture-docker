#!/bin/sh
set -e

if [ ! -e /var/www/html/aperture/.env ]; then
    cd /var/www/html

    git clone https://github.com/aaronpk/Aperture.git .

    cd aperture

    composer install

    cp .env.example .env

    chown -R www-data:www-data .

    sed -i "s|APP_ENV=local|APP_ENV=production|g" .env
    sed -i "s|APP_DEBUG=true|APP_DEBUG=false|g" .env
    sed -i "s|APP_URL=http://localhost|APP_URL=${WATCHTOWER_CB:=https\://aperture.example.org}|g" .env

    sed -i "s|WATCHTOWER_URL=https://watchtower.dev|WATCHTOWER_URL=${WATCHTOWER_URL:=https\://watchtower.example.org}|g" .env
    sed -i "s|WATCHTOWER_CB=https://aperture.dev|WATCHTOWER_CB=${WATCHTOWER_CB}|g" .env
    sed -i "s|WATCHTOWER_TOKEN=1234|WATCHTOWER_TOKEN=${WATCHTOWER_TOKEN:=1234}|g" .env

    sed -i "s|IMG_PROXY_URL=https://aperture-proxy.p3k.io/|IMG_PROXY_URL=|g" .env
    
    sed -i "s|DB_HOST=127.0.0.1|DB_HOST=${MYSQL_HOST:=127.0.0.1}|g" .env
    sed -i "s|DB_PASSWORD=secret|DB_PASSWORD=${MYSQL_PASSWORD:=aperture}|g" .env

    sed -i "s|REDIS_HOST=127.0.0.1|REDIS_HOST=${REDIS_HOST:=127.0.0.1}|g" .env
    sed -i "s|REDIS_PASSWORD=null|REDIS_PASSWORD=${REDIS_PASSWORD:=null}|g" .env

    sed -i "s|SQL_LOG_QUERIES=true|SQL_LOG_QUERIES=false|g" .env
    sed -i "s|SQL_LOG_SLOW_QUERIES=true|SQL_LOG_SLOW_QUERIES=false|g" .env
fi

exec "$@"

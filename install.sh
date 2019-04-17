#!/bin/sh
function php(){
    docker run --name php -p 9000:9000 -p 11211:11211 -p 6379:6379 \
    -v /data/php/conf/php-fpm.d/www.conf:/usr/local/etc/php-fpm.d/www.conf \
    -v /data/php/log:/usr/local/var/log \
    -v /data/www:/usr/share/nginx/html \
    -d php:7.2.16-fpm
}

function nginx(){
    docker run --name nginx -p 80:80 \
    -v /data/nginx/conf/conf.d/default.conf:/etc/nginx/conf.d/default.conf \
    -v /data/nginx/log:/var/log/nginx \
    -v /data/www:/usr/share/nginx/html \
    -d nginx:1.15.9
}

function mysql(){
    docker run --name mysql -p 3306:3306 \
    -v /data/mysql/data:/var/lib/mysql \
    -v /data/mysql/log:/var/log/mysql \
    -v /data/mysql/conf:/etc/mysql/mysql.conf.d \
    -e MYSQL_ROOT_PASSWORD=test123456 \
    -d mysql:5.7.25
}
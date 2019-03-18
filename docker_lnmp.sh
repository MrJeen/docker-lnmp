#!/bin/bash

function mysql()
{
    docker run --name mysql --restart=always --net lnmp -p 3306:3306 \
    -v /data/mysql/data:/var/lib/mysql \
    -v /data/mysql/conf:/etc/mysql/conf.d \
    -v /data/mysql/logs:/logs \
    -e MYSQL_ROOT_PASSWORD=test123456 \
    -d mysql:5.7 --character-set-server=utf8
}

function php()
{
    docker run --name php --restart=always --net lnmp \
    -v /data/nginx/html:/data/nginx/html \
    -v /data/php/log:/data/php/var/log \
    -d php:7.2.16
}

function nginx()
{
    docker run --name nginx --restart=always --net lnmp -p 80:80 \
    -v /data/nginx/html:/data/nginx/html \
    -v /data/nginx/logs:/data/nginx/logs \
    -d nginx:1.15.9
}
$1
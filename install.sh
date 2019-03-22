#!/bin/bash

#data
git clone https://github.com/MrJeen/docker-lnmp.git \

#php-fpm
docker pull php:7.2.16-fpm \
docker run --name php -p 9000:9000 \
​	-v /data/php/etc/php-fpm.d/www.conf:/usr/local/etc/php-fpm.d/www.conf \
​	-v /data/php/log:/usr/local/var/log \
​	-v /data/www:/usr/share/nginx/html \
​	-d php:7.2.16-fpm \

#nginx
docker pull nginx:1.15.9 \
​docker run --name nginx -p 80:80 \
​	-v /data/nginx/conf/conf.d/default.conf:/etc/nginx/conf.d/default.conf \
​	-v /data/nginx/log:/var/log/nginx \
​	-v /data/www:/usr/share/nginx/html \
​	-d nginx:1.15.9 \

#mysql
docker pull mysql:5.7.25 \
​docker run --name mysql -p 3306:3306 \
​    -v /data/mysql/data:/var/lib/mysql \
​	-v /data/mysql/log:/var/log/mysql \
​	-v /data/mysql/conf:/etc/mysql/mysql.conf.d \
​	-e MYSQL_ROOT_PASSWORD=123456 \ 
​    -d mysql:5.7.25 --character-set-server=utf8


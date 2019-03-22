# docker-lnmp

#复制data目录到宿主机下



1、安装php-fpm 



​	docker pull php:7.2.16-fpm



​	docker run --name php -p 9000:9000 -p 11211:11211 -p 6379:6379\

​	-v /data/php/etc/php-fpm.d/www.conf:/usr/local/etc/php-fpm.d/www.conf \

​	-v /data/php/log:/usr/local/var/log \

​	-v /data/www:/usr/share/nginx/html \ #这里填代码目录的路径，必填，在nginx里解析PHP的时候需要用

​	-d php:7.2.16-fpm

​	

​	

2、安装nginx

​	

​	docker pull nginx:1.15.9

​	

​	docker run --name nginx -p 80:80 \

​	-v /data/nginx/conf/conf.d/default.conf:/etc/nginx/conf.d/default.conf \

​	-v /data/nginx/log:/var/log/nginx \

​	-v /data/www:/usr/share/nginx/html \

​	-d nginx:1.15.9

​	

​	#查看php-fpm的IP

​	docker inspect php | grep "IPAddress"

​	

​	#配置nginx  /data/nginx/conf/conf.d/default.conf（data文件夹里已配置好）

​	

​	location ~ \.php$ {

​        	root           html;

​       	 	fastcgi_pass   172.17.0.2:9000;  #这里要填php-fpm的IP

​        	fastcgi_index  index.php;

​      		fastcgi_param  SCRIPT_FILENAME  /usr/share/nginx/html$fastcgi_script_name;  #这里填代码目录的路径

​        	include        fastcgi_params;

   	 }



3、安装mysql

​	

​	docker pull mysql:5.7.25

​	

​	docker run --name mysql -p 3306:3306 \

​    	-v /data/mysql/data:/var/lib/mysql \

​	-v /data/mysql/log:/var/log/mysql \

​	-v /data/mysql/conf:/etc/mysql/mysql.conf.d \

​	-e MYSQL_ROOT_PASSWORD=123456 \   #密码必须要设置

​    	-d mysql:5.7.25 --character-set-server=utf8



4、安装PHP扩展  <https://hub.docker.com/_/php>

docker exec -it php /bin/bash

cd /usr/local/bin 

 ./docker-php-ext-install pdo_mysql  

./docker-php-ext-install mysqli

重启容器



安装pecl扩展

cd /usr/local/bin 

apt-get update && apt-get install -y libmemcached-dev zlib1g-dev

pecl install memcached-3.1.3

docker-php-ext-enable memcached



使用memcached

$memcache = new memcached();

$memcache->addServer("172.17.0.2","11211");



5、连接数据库

查看mysql的IP

docker inspect mysql | grep "IPAddress"

mysqli_connect("172.17.0.4","root","123456","test");  #这里的IP要填mysql容器的IP



6、

#复制容器的目录到宿主机   docker cp <containerId>:/file/path/within/container /host/path/target

#复制宿主机目录到容器   docker cp /host/path/target <containerId>:/file/path/within/container
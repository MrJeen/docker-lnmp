# docker-lnmp

#复制data目录到宿主机下



一、安装docker

https://yeasy.gitbooks.io/docker_practice/content/install/ubuntu.html



二、搭建环境



1、安装php-fpm 



​	docker pull php:7.2.16-fpm



​	docker run --name php -p 9000:9000 \

​	-v /data/php/conf/php-fpm.d/www.conf:/usr/local/etc/php-fpm.d/www.conf \

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

​       	 	fastcgi_pass   172.17.0.2:9000;  #这里要填php-fpm的IP   （如果创建容器的时候加上--link php:php，这里就可以直接用php了，不需要IP）

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

​	-e MYSQL_ROOT_PASSWORD=test123456 \   #密码必须要设置

​    	-d mysql:5.7.25



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



安装memcached

​	docker pull memcached:1.5.12

​	docker run --name memcached -p 11211:11211\

​	-d memcached:1.5.12



使用memcached，先查看memcached服务端IP，比如是 172.17.0.5

​	$memcache = new memcached();

​	$memcache->addServer("172.17.0.5","11211");



如果安装gd扩展失败时，需要安装libpng依赖，也可能需要更换debian源，可以参考

http://mirrors.ustc.edu.cn/help/debian.html



5、连接数据库

查看mysql的IP

docker inspect mysql | grep "IPAddress"

mysqli_connect("172.17.0.4","root","123456","test");  #这里的IP要填mysql容器的IP



6、

#复制容器的目录到宿主机   docker cp <containerId>:/file/path/within/container /host/path/target

#复制宿主机目录到容器   docker cp /host/path/target <containerId>:/file/path/within/container



7、composer

直接安装composer，不在PHP容器里装，使用起来会比较麻烦：

有时候需要使用composer来安装PHP包，比如laravel，但是php-fpm镜像中并没有composer。所以我们再装一个composer镜像

```
docker pull composer
```

运行composer容器和运行php或者nginx容器不同，它不需要后台运行，而是使用命令行交互模式，即不使用`-d`，使用`-it`。同时composer是在PHP项目跟目录运行，所以也需要挂载`/docker/www`目录

```
docker run -it --name composer -v /docker/www:/app --privileged=true composer <要执行的composer命令>
```

比如新建laravel项目

```
docker run -it --name composer -v /docker/www:/app --privileged=true composer composer create-project --prefer-dist laravel/laravel ./ 5.5.*
```

8、修改容器配置

停止 docker 容器，systemctl stop docker 或者 service docker stop，然后进入宿主机/var/lib/docker/containers目录，找到对应的容器ID，在容器目录里修改修改 hostconfig.json 和 config.v2.json，最后启动容器 systemctl start docker

如：

"Links":[
​        "php:php"
​    ],

"RestartPolicy":{
​        "Name":"always",
​        "MaximumRetryCount":0
​    },
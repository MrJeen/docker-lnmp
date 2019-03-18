# docker-lnmp
1、系统环境

​	操作系统版本：Centos （最新版）

​	Docker版本：18.09.3-ce（社区版）

​	Nginx版本：1.15.9

​	PHP版本：7.2.16

​	Mysql版本：5.7.25

2、nginx和php源码包已下载好，需要切换其他版本需要另外下载，并且修改相应的Dockerfile文件

3、构建php镜像

​	cd dockerfile/php/

​	docker build -t php:7.2.16 .	（注意后面的小数点）

4、构建nginx镜像

​	cd ../nginx/

​	docker build -t nginx:1.15.9 .	（注意后面的小数点）

5、下载mysql镜像

​	源码安装生成的镜像文件太大，而且操作步骤比较复杂，这里弃用了源码安装，而选择直接使用官方镜像。

​	docker pull mysql:5.7.25

​	docker images

6、创建并启动容器

​	（1）创建自定义网络lnmp

​		docker network create lnmp

​		docker network ls

​	（2）启动mysql、php、nginx容器

​		sh docker_lnmp.sh mysql

​		sh docker_lnmp.sh php

​		sh docker_lnmp.sh nginx

​	（3）查看容器是否都成功启动

​		docker ps

​	（4）修改mysql的密码加密方式为mysql_native_password

​		vim /data/mysql/conf/docker_mysql.cnf

​			[mysqld]
​			default-authentication-plugin=mysql_native_password	

​		如果不修改加密方式的话，低版本的mysql客户端登陆时会报错

​		重启mysql容器

​		docker restart mysql



​	



#php

#安装centos系统
FROM centos:latest

#声明作者
MAINTAINER djy<junyuan009@163.com>

#设置时区
ENV TIME_ZOME Asia/Shanghai

#定义php版本，与源码包一致
ARG PV="php-7.2.16"

#复制php源码包到tmp目录
ADD $PV.tar.gz /tmp

RUN yum -y install gcc gcc-c++ make gd-devel libxml2-devel libcurl-devel libjpeg-devel libpng-devel openssl-devel bison \
    && mkdir -p /data \
    && cd /tmp/$PV \
    && ./configure --prefix=/data/php \
        --with-config-file-path=/data/php/etc \
        --with-gd --with-mysqli \
        --with-openssl --with-zlib --with-curl \
        --with-jpeg-dir --with-png-dir --with-iconv \
        --enable-fpm --enable-zip --enable-mbstring \
    && make -j 4 \
    && make install \
    && cp /data/php/etc/php-fpm.conf.default /data/php/etc/php-fpm.conf \
    && cp /data/php/etc/php-fpm.d/www.conf.default /data/php/etc/php-fpm.d/www.conf \
    && sed -i '/;daemonize/a\daemonize = no' /data/php/etc/php-fpm.conf \
    && sed -i 's/127.0.0.1/0.0.0.0/g' /data/php/etc/php-fpm.d/www.conf \
    && echo "${TIME_ZOME}" > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/${TIME_ZOME} /etc/localtime \
    && rm -rf /tmp/php* \
    && yum clean all \
    && yum -y remove gcc gcc-c++ make

#设置CMD指明的命令的运行目录
WORKDIR /data/php/

#指定端口，使容器内的应用可以通过端口和外界交互
EXPOSE 9000

#CMD和RUN命令相似，但只能是在用镜像构建容器后被调用，参数“-c” 指定了配置文件的路径
CMD ["sbin/php-fpm","-c","etc/php-fpm.conf"]

#make -j4，让make最多允许4个编译命令同时执行
#daemonize = no表示fpm在前台运行
#sed -i 直接修改读取的文件内容；其中 a：新增，a 的后面可以接字串，而这些字串会在新的一行出现(目前的下一行)；s ：取代，可以直接进行取代的工作
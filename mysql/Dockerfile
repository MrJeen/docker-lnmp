
#mysql5.7.25 带boost

#安装centos系统
FROM centos:latest

#声明作者
MAINTAINER djy<junyuan009@163.com>

#设置时区
ENV TIME_ZOME Asia/Shanghai

#定义mysql版本，与源码包一致
ARG MV="mysql-boost-5.7.25"
ADD $MV.tar.gz /tmp

RUN yum -y install make gcc gcc-c++ cmake bison-devel ncurses-devel bison perl perl-devel perl perl-devel \
	&& groupadd mysql \
	&& useradd -r -g mysql -s /bin/false mysql \
	&& mkdir -p /data \
    && cd /tmp/$PV \
	&& cmake -DCMAKE_INSTALL_PREFIX=/data/mysql \  
	   -DMYSQL_DATADIR=/data/mysql/data \ 
	   -DMYSQL_USER=mysql \ 
	   -DSYSCONFDIR=/data/mysql/etc \ 
	   -DDEFAULT_CHARSET=utf8 \ 
	   -DDEFAULT_COLLATION=utf8_general_ci \ 
	   -DWITH_BOOST=boost \
	&& make -j 2 \
    && make install \
	&& cd /data/mysql \
	&& chown -R mysql . \
	&& chgrp -R mysql . \
	&& cd /data/mysql/bin \
	&& ./mysqld --initialize-insecure --user=mysql --basedir=/data/mysql --datadir=/data/mysql/data \
	&& ./mysql_ssl_rsa_setup  --user=mysql --basedir=/data/mysql --datadir=/data/mysql/data \
	
	&& echo "${TIME_ZOME}" > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/${TIME_ZOME} /etc/localtime \
	&& rm -rf /tmp/mysql* \
    && yum clean all \
    && yum -y remove gcc gcc-c++ make
	
WORKDIR /data/mysql/
EXPOSE 3306
CMD ["mysqld"]




#安装centos系统
FROM centos:latest

#声明作者
MAINTAINER djy<junyuan009@163.com>

#设置时区
ENV TIME_ZOME Asia/Shanghai

#定义nginx版本，与源码包一致
ARG NV="nginx-1.15.9"

#安装目录
ARG INSTALL_PATH=/data

COPY nginx.conf /$INSTALL_PATH/nginx/conf/
ADD $NV.tar.gz /tmp

#使用ADD的唯一原因就是你有一个压缩文件，你想自动解压到镜像中。否则都使用COPY

RUN yum -y install gcc gcc-c++ make openssl-devel pcre-devel \
        && mkdir -p /$INSTALL_PATH \
        && cd /tmp/$NV \
        && ./configure --prefix=/$INSTALL_PATH/nginx \
        && make -j 2 \
        && make install \
        && echo "${TIME_ZOME}" > /etc/timezone \
        && ln -sf /usr/share/zoneinfo/${TIME_ZOME} /etc/localtime \
        && rm -rf /tmp/nginx* \
        && yum clean all \
        && yum -y remove gcc gcc-c++ make

#设置CMD指明的命令的运行目录
WORKDIR /$INSTALL_PATH/nginx/

#指定端口，使容器内的应用可以通过端口和外界交互
EXPOSE 80

#CMD和RUN命令相似，但只能是在用镜像构建容器后被调用，使用daemon off的方式将nginx运行在前台保证镜像不至于退出
CMD ["./sbin/nginx","-g","daemon off;"]
FROM centos:7.9.2009

USER root

WORKDIR /nginx

COPY nginx.conf /code/

RUN yum -y install wget git pcre-devel zlib-devel gcc-c++ gcc automake autoconf libtool make patch
RUN wget http://nginx.org/download/nginx-1.15.12.tar.gz
RUN wget https://raw.githubusercontent.com/chobits/ngx_http_proxy_connect_module/master/patch/proxy_connect_rewrite_101504.patch
RUN git clone https://github.com/chobits/ngx_http_proxy_connect_module.git
RUN tar zxvf nginx-1.15.12.tar.gz
RUN cd nginx-1.15.12 && \
    patch -p1 < /nginx/proxy_connect_rewrite_101504.patch && \
    ./configure --add-module=/nginx/ngx_http_proxy_connect_module && \
    make && \
    make install

RUN mv /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf.bak

COPY nginx.conf /usr/local/nginx/conf/nginx.conf

RUN ln -sf /usr/local/nginx/sbin/nginx /usr/local/sbin/nginx

RUN nginx -t

EXPOSE 8888

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]


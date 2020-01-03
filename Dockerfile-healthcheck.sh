FROM alpine

LABEL maintainer="ThaoPT <thaopt@peacesoft.net> - Nextsec.vn"

ENV NGINX_VERSION nginx-1.16.1

RUN apk add --no-cache --virtual .build-deps \
        gcc \
        libc-dev \
        make \
        openssl-dev \
        pcre-dev \
        zlib-dev \
        linux-headers \
        curl \
        gnupg \
        libxslt-dev \
        gd-dev \
        perl-dev \
    && apk add --no-cache --virtual .libmodsecurity-deps \
        pcre-dev \
        libxml2-dev \
        git \
        libtool \
        automake \
        autoconf \
        g++ \
        flex \
        bison \
        yajl-dev \
		patch \
		make \
    # Add runtime dependencies that should not be removed
    && apk add --no-cache \
        doxygen \
        geoip \
        geoip-dev \
        yajl \
        libstdc++ \
        git \
        sed \
        libmaxminddb-dev

WORKDIR /tmp

RUN echo 'Clone Healthcheck - Nginx connector' && \
    cd /tmp/ && git clone --depth 1 https://github.com/yaoweibin/nginx_upstream_check_module.git

RUN apk --update add openssl-dev pcre-dev zlib-dev wget build-base && \
    mkdir -p /tmp/src && \
    cd /tmp/src && \
    wget http://nginx.org/download/${NGINX_VERSION}.tar.gz && \
    tar -zxvf ${NGINX_VERSION}.tar.gz && \
    cd /tmp/src/${NGINX_VERSION} && \
	/usr/bin/patch -p1 < /tmp/nginx_upstream_check_module/check_1.16.1+.patch && \
    ./configure \
		--add-module=/tmp/nginx_upstream_check_module \
        --with-http_ssl_module \
        --with-http_gzip_static_module \
        --prefix=/etc/nginx \
        --http-log-path=/var/log/nginx/access.log \
        --error-log-path=/var/log/nginx/error.log \
        --sbin-path=/usr/local/sbin/nginx && \
    make && \
    make install && \
    apk del build-base && \
    rm -rf /tmp/src && \
    rm -rf /var/cache/apk/*
	
#delete uneeded and clean up
RUN apk del .build-deps && \
	apk del .libmodsecurity-deps
	
# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/log/nginx"]

WORKDIR /etc/nginx

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]

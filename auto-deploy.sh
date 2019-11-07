#!/bin/bash


mkdir -p /data/nginx/conf.d/ssl
mkdir -p /data/nginx/log
mkdir -p /data/modsec/log

cat > /data/nginx/conf.d/demo.conf << EOL

#HTTP redirect
server {
        listen  80;
        server_name sub.domain.com;
        return 301 https://sub.domain.com$request_uri;
       }


##### Enable for Root domain only - Chỉ dùng khi cấu hình doamin chính với WWW.domain.com
#server {
#	listen 443 ssl;

#	server_name www.domain.com;
	
#	# SSL
#	ssl_certificate /etc/nginx/ssl/www.doamin.com/www.domain.com.crt;
#	ssl_certificate_key /etc/nginx/ssl/www.doamin.com.pri.key;

#	return 301 https://doamin.com$request_uri;

#	include /etc/nginx/general.conf;
#}


server {
        listen 443 ssl;
        server_name     sub.domain.com;

        access_log      /var/log/nginx/sub.domain.com_access.log main;
        error_log       /var/log/nginx/sub.domain.com_error.log;

        sub_filter http://sub.domain.com https://sub.domain.com;
		sub_filter http://www.domain.com https://www.domain.com;
        sub_filter_once on;
        include /etc/nginx/general.conf;

#        ssl_certificate /etc/nginx/conf.d/ssl/certificate/sub.domain.com.crt;
#       ssl_certificate_key /etc/nginx/conf.d/ssl/certificate/sub.domain.com.key;

        #Reverse proxy
        location / {
             proxy_pass         http://WEB-APP-IP:PORT;
             include /etc/nginx/proxy.conf;
             }
}


EOL

cat > docker-compose.yml << EOL

version: '3'

services:
   modsec:
     image: "wisoez/nginx-modsecurity-crs:latest"
     volumes:
       - "/data/nginx/conf.d:/etc/nginx/conf.d"
       - "/data/nginx/log:/var/log/nginx"
       - "/data/modsec/log:/var/log/modsec"
     restart: "always"
     ports:
       - "80:80"
       - "443:443"
EOL

/bin/docker-compose up
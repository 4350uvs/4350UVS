#!/bin/bash

########################################
#
# Run web2py app
#
# Version 1 - umbruner
#
########################################

cd /
cd /etc/nginx/sites-available/

echo "Updated nginx config file.";

echo "server {
        listen 80;

        location / {
               proxy_pass http://127.0.0.1:8001/4350app/;
               proxy_set_header  X-Real-IP  $remote_addr;
        }
}

server {
        listen 127.0.0.1:8001;

        location / {
               uwsgi_pass      127.0.0.1:9001;
               include         uwsgi_params;
               uwsgi_param     UWSGI_SCHEME $scheme;
               uwsgi_param     SERVER_SOFTWARE    nginx/$nginx_version;
        }
}

server {
        listen 443;

        ssl                     on;
        ssl_certificate         /etc/nginx/ssl/web2py.crt;
        ssl_certificate_key     /etc/nginx/ssl/web2py.key;

        location / {
                uwsgi_pass      127.0.0.1:9001;
                include         uwsgi_params;
                uwsgi_param     UWSGI_SCHEME $scheme;
                uwsgi_param     SERVER_SOFTWARE    nginx/$nginx_version;
        }

}" > web2py

cd /
cd /home/www-data/web2py/

echo "routes_out = (
  ('/4350app/(?P<any>.*)', '/\g<any>'),
)" > routes.py

echo "Reloading nginx."

sudo /etc/init.d/nginx reload

echo "Finished web2py portion. Time to check. If you see the app on your public dns address, it works.";

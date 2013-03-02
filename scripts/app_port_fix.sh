#!/bin/bash

########################################
#
# Run web2py app
#
# Version 1 - umbruner
#
########################################

echo "Add an inbound rule TCP port 8274 to Security Group.";
read -sp "Press [Enter] key to continue... "

cd /
cd /etc/nginx/sites-available/

echo "Updating nginx config file.";

echo "server {
        listen 8274;

        location / {
               proxy_pass http://127.0.0.1:8001/4350api/;
               proxy_set_header  X-Real-IP  $remote_addr;
        }
}

server {
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
  ('/4350api/(?P<any>.*)', '/\g<any>'),
)

routes_in = (
  ('/4350api/', '/4350api/default/index'),
  ('/4350api/(?P<any>.*)', '/4350api/default/api/\g<any>'),
)" > routes.py

echo "Reloading uwsgi."
sudo /etc/init.d/uwsgi reload

echo "Reloading nginx."
sudo /etc/init.d/nginx reload

echo "Finished the port fix. Time to check if it works. If you see the app on your public dns address, it works.";
echo "If you see the api on [your dns]:8274, the api works.";

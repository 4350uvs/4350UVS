#!/bin/bash

########################################
#
# Installation Script for Ubuntu, etc
#
# Version 1 - umbruner
#
########################################

cd /home
sudo chown -R ubuntu /home
mkdir www-data
cd www-data

wget http://web2py.com/examples/static/web2py_src.zip
sudo bash
apt-get -y install unzip
unzip web2py_src.zip
rm web2py_src.zip

chown -R www-data:www-data web2py
cd /home/www-data/web2py

read -p "Enter password for web2py admin: " PW

sudo -u www-data python -c "from gluon.main import save_password; save_password('$PW',443)"

add-apt-repository ppa:nginx/stable
apt-get update
apt-get -y install nginx

echo "Under security groups in AWS make an inbound rule for http - 80. Click add rule and then apply.";
read -sp "Press [Enter] key to continue... "

sudo /etc/init.d/nginx start

add-apt-repository  ppa:uwsgi/release
apt-get update
apt-get -y install uwsgi uwsgi-plugin-python

sudo chown -R ubuntu /etc/uwsgi/apps-available/
echo "Create a file /etc/uwsgi/apps-available/web2py.xml -The permissions have already been changed for you.";
read -sp "Press [Enter] key to continue... "

ln -s /etc/uwsgi/apps-available/web2py.xml /etc/uwsgi/apps-enabled/web2py.xml

mkdir /etc/nginx/ssl
cd /etc/nginx/ssl
openssl genrsa -out web2py.key 1024
openssl req -batch -new -key web2py.key -out web2py.csr
openssl x509 -req -days 1780 -in web2py.csr -signkey web2py.key -out web2py.crt

sudo chown -R ubuntu /etc/nginx/sites-available/
echo "Create a file /etc/nginx/sites-available/web2py -Permissions already changed for you.";
read -sp "Press [Enter] key to continue... "

ln -s /etc/nginx/sites-available/web2py /etc/nginx/sites-enabled/web2py

sudo /etc/init.d/uwsgi start
sudo /etc/init.d/nginx reload

echo "Finish rest of installation guide";
read -sp "Press [Enter] key to continue... "

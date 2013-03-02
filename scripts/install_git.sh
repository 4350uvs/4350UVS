#!/bin/bash

########################################
#
# Install git
#
# Version 1 - umbruner
#
########################################

cd /

echo "Installing git.";

apt-get -y install git

cd /home/www-data/web2py/applications
git clone https://github.com/4350uvs/4350api.git
cd 4350api
mkdir languages

echo "Check your public dns \[your public dns\]:8274";
read -sp "Press [Enter] key to continue... "

cd /home/www-data/web2py/applications
git clone https://github.com/4350uvs/4350app.git
cd 4350app
mkdir languages

echo "Check your public dns \[your public dns\]";
read -sp "Press [Enter] key to continue... "
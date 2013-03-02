#!/bin/bash

########################################
#
# Permission/Access changes
#
# Version 1 - umbruner
#
########################################

cd /

echo "Changing permissions and access.";

sudo usermod -a -G www-data ubuntu

sudo chmod g+rw /home/www-data/ -R

sudo chown -R www-data:www-data /home/www-data


echo -e "Done changing permissions";
read -sp "Press [Enter] key to continue... `echo $'\n '`"
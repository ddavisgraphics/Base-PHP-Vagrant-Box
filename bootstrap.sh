#!/bin/bash

echo "Developer Tools install"
yum -y update
yum -y groupinstall "Development Tools"

yum -y install emacs emacs-common emacs-nox git wget \
sqlite-devel expect \
screen curl-devel openssl-devel readline-devel ruby-devel  tcl \
ImageMagick-devel nasm libxml2-devel libxslt-devel libyaml-devel

yum -y install php php-bcmath php-cli php-common php-gd php-ldap php-mbstring php-mcrypt php-mysql php-odbc php-pdo php-pear php-pear-Benchmark php-pecl-apc php-pecl-imagick php-pecl-memcache php-soap php-xml php-xmlrpc 


## Installing Apache and starting the httpd service
## =================================================================
yum -y install httpd httpd-devel httpd-manual httpd-tools \
mod_auth_kerb mod_auth_mysql mod_authz_ldap mod_ssl mod_wsgi

# start apache
systemctl start httpd.service 

## mysql 
## =================================================================
rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
yum -y install mysql-community-server mysql-community-client mysql-community-devel mysql-community-common mysql-community-libs mysql-community-release

echo "Setting Up MySQL."

systemctl enable mysqld
systemctl restart mysqld

#set password to root 

/usr/bin/mysqladmin -u root password 'password'

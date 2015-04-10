#!/usr/bin/env bash 

echo "setting up the forwarding the app to the www"

rm -rf /var/www 
ln -fs /vagrant /var/www

## Installing the Development Environments 
## ======================================= 

# Update the system make sure its good to go 
yum -y install update

############
# Base Setup

yum groupinstall -y "Development Tools"

yum -y install emacs emacs-common emacs-nox git wget \
sqlite-devel expect \
screen curl-devel openssl-devel readline-devel ruby-devel  tcl \
ImageMagick-devel nasm libxml2-devel libxslt-devel libyaml-devel

#install the httpd RPMs
yum -y install httpd httpd-devel httpd-manual httpd-tools \
mod_auth_kerb mod_auth_mysql mod_authz_ldap mod_ssl mod_wsgi

# Setup apache virtual hosts directory
mkdir -p /etc/httpd/virtualHosts/
echo "NameVirtualHost *:80" | tee -a /etc/httpd/conf/httpd.conf
echo "IncludeOptional virtualHosts/*.conf" | tee -a /etc/httpd/conf/httpd.conf

systemctl enable httpd

## Setup db

rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
yum -y install mysql-community-server mysql-community-client mysql-community-devel mysql-community-common mysql-community-libs mysql-community-release

echo "Setting Up MySQL."

systemctl enable mysqld
systemctl restart mysqld

mysql -u root < install/mysqlFedora3Setup.sql
/usr/bin/mysqladmin -u root password 'password'

yum -y install java-1.7.0-openjdk-devel tomcat tomcat-admin-webapps tomcat-webapps

###############
## Tomcat Setup

# Add the current user (root in vagrant) to the tomcat group
# we are speificaly using both of these, if you SU to root, without a -, $USER
# is still the original logged in user
/usr/sbin/usermod -G tomcat -a $USER
/usr/sbin/usermod -G tomcat -a root

# Start tomcat
systemctl restart tomcat

#ensure that tomcat starts at boot
systemctl enable tomcat

# Setup a rule to allow connections on port 8080
# @TODO port should be configurable in the env 
echo "Be sure to open port 8080 on the server"
echo "/usr/sbin/iptables -A INPUT -p tcp -m tcp -m state --dport 8080 --state NEW -j ACCEPT"




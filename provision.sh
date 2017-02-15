#!/bin/bash

#provisioning for ubuntu 14.X
echo "Installing Java JDK"
echo "...."
echo "..."
echo ".."
#prerequisite for elkstack
apt-get -y install openjdk-8-jre-headless

# INSTALL ELASTICSEARCH 5.X
echo "Installing ELASTICSEARCH 5.X"
echo "...."
echo "..."
echo ".."
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
#update applies for elasticsearch kibana and logstash
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
apt-get -y update
apt-get -y install elasticsearch
systemctl enable elasticsearch.service
sed -i 's/#network.host: 192.168.0.1/network.host: localhost/g' /etc/elasticsearch/elasticsearch.yml
#if you dont have enough memory, reduce requirement else es wont start.
# by uncommenting the below.
sed -i 's/-Xms2g/-Xms512m/g' /etc/elasticsearch/jvm.options
sed -i 's/-Xmx2g/-Xmx512m/g' /etc/elasticsearch/jvm.options
systemctl start elasticsearch.service

# INSTALL KIBANA 5.X kibana version 5.X
echo "Installing KIBANA 5.X"
echo "...."
echo "..."
echo ".."
apt-get update && sudo apt-get -y install kibana
#sed -i 's/#service.host: 0.0.0.0/service.host: localhost/g' /etc/kibana/kibana.yml
systemctl enable kibana.service
systemctl start kibana.service

# INSTALL NGINX
echo "Installing NGINX"
apt-get -y install nginx apache2-utils
#create kibana user "kibanaadmin" and password
sudo htpasswd -bc /etc/nginx/htpasswd.users kibanaadmin Password1

#replace /etc/nginx/sites-available/default WITH nginxproxy
> /etc/nginx/sites-available/default
cp .nginxproxy /etc/etc/nginx/sites-available/default
# append server name with hostname
sed -i 's/server_name example.com;/server_name '$HOSTNAME'.com;/g' /etc/nginx/sites-available/default
systemctl restart nginx.service

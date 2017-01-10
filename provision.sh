#!/bin/bash

#install java jdk and jre
apt-get -y install default-jdk

#install elasticsearch version 5.X
echo "Installing Elasticsearch"
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
apt-get -y update
apt-get -y install elasticsearch
sed -i 's/#network.host: 192.168.0.1/network.host: localhost/g' /etc/elasticsearch/elasticsearch.yml
sed -i 's/-Xms2g/-Xms512m/g' /etc/elasticsearch/jvm.opt
sed -i 's/-Xmx2g/-Xmx512m/g' /etc/elasticsearch/jvm.options
systemctl enable elasticsearch.service
systemctl start elasticsearch.service

#install kibana version 5.X
apt-get -y install kibana
systemctl enable kibana
systemctl start kibana

#install nginx
apt-get -y install nginx
systemctl enable kibana
systemctl restart nginx.service

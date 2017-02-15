#!/bin/bash

#provisioning for ubuntu 14.X
# INSTALLL JAVA AND JRE
apt-get -y install default-jdk

# INSTALL ELASTICSEARCH 5.X
echo "Installing Elasticsearch"
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
apt-get -y update
apt-get -y install elasticsearch
sed -i 's/#network.host: 192.168.0.1/network.host: localhost/g' /etc/elasticsearch/elasticsearch.yml
sed -i 's/-Xms2g/-Xms512m/g' /etc/elasticsearch/jvm.options
sed -i 's/-Xmx2g/-Xmx512m/g' /etc/elasticsearch/jvm.options
systemctl enable elasticsearch.service
systemctl start elasticsearch.service

# INSTALL KIBANA 5.X kibana version 5.X
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
apt-get update && sudo apt-get -y install kibana
sed -i 's/#service.host: 0.0.0.0/service.host: localhost/g' /etc/kibana/kibana.yml
systemctl enable kibana.service
systemctl start kibana.service

# INSTALL NGINX
apt-get -y install nginx apache2-utils
#create kibana user "kibanaadmin"
htpasswd -c /etc/nginx/htpasswd.users kibanaadmin
#replace /etc/nginx/sites-available/default WITH nginxproxy
mv nginxproxy /etc/nginx/sites-available/default
systemctl restart nginx.service


# INSTALL LOGSTASH
#echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
sudo apt-get update && sudo apt-get install kibana

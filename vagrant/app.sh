#! /bin/bash
# this is script for app VM
sudo yum install -y java
sudo mkdir /usr/local/tomcat
cd /usr/local/tomcat
sudo wget http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-8/v8.5.3/bin/apache-tomcat-8.5.3.tar.gz
sudo tar -xvzf apache-tomcat-8.5.3.tar.gz
sudo chmod -R 777 /usr/local/tomcat
cd apache-tomcat-8.5.3/bin/
./startup.sh

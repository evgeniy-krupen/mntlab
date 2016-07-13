#! /bin/bash
# this is script for web VM
sudo yum install -y gcc
sudo yum install -y httpd-devel.x86_64
sudo yum install -y httpd
wget http://archive.apache.org/dist/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.41-src.tar.gz
tar -xvzf tomcat-connectors-1.2.41-src.tar.gz
cd tomcat-connectors-1.2.41-src/native
 ./configure --with-apxs=/usr/sbin/apxs
sudo make
sudo make install
sudo service httpd restart
		## for worker.properties
sudo touch /etc/httpd/conf/worker.properties
cd /etc/httpd/conf
sudo chmod 777 worker.properties
echo 'worker.list=tomcat' >> worker.properties
echo 'worker.tomcat.port=8009' >> worker.properties
echo 'worker.tomcat.host=192.168.25.11' >> worker.properties
echo 'worker.tomcat.type=ajp13' >> worker.properties
echo 'worker.tomcat.lbfactor=1' >> worker.properties
sudo chmod 644 worker.properties
		## edit httpd.conf
sudo chmod 777 httpd.conf
echo 'ServerName 192.168.25.10' >> httpd.conf
echo 'LoadModule jk_module modules/mod_jk.so' >> httpd.conf
echo 'JkWorkersFile /etc/httpd/conf/worker.properties' >> httpd.conf
echo 'JkLogFile /etc/httpd/logs/mod_jk.log' >> httpd.conf
echo 'JkLogLevel info' >> httpd.conf
echo 'JkLogStampFormat "[%a %b %d %H:%M:%S %Y] "' >> httpd.conf
echo 'JkOptions +ForwardKeySize +ForwardURICompat -ForwardDirectories' >> httpd.conf
echo 'JkRequestLogFormat "%w %V %T"' >> httpd.conf
echo '<VirtualHost *:80>' >> httpd.conf
echo '       ServerName 192.168.25.10' >> httpd.conf
echo '        JkMount /* tomcat' >> httpd.conf
echo '</VirtualHost>' >> httpd.conf
sudo chmod 644 httpd.conf

sudo service httpd restart

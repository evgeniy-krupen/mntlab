#!/bin/bash
# for troubleshooting
echo "hello world"
# fix httpd.conf, add # in 6 lines
sed -i '/^<VirtualHost/,+6 s/^/#/' /etc/httpd/conf/httpd.conf
# fix mntlab to * in vhost.conf
sed -i 's/mntlab/*/g' /etc/httpd/conf.d/vhost.conf
# fix tomcat's bashrc file
sed -i '/export/s/^/# /' /home/tomcat/.bashrc
# change owner folder logs from root to tomcat
chown tomcat:tomcat /opt/apache/tomcat/current/logs/
# change java version
alternatives --config java <<<1
# fix mistakes in workers.properties
sed -i 's/192.168.56.100/192.168.56.10/' /etc/httpd/conf.d/workers.properties
sed -i 's/worker-jk@ppname/tomcat.worker/g' /etc/httpd/conf.d/workers.properties
# fix iptables
chattr -i /etc/sysconfig/iptables
cp -f /vagrant/sources/iptables /etc/sysconfig/
service iptables restart
chattr +i /etc/sysconfig/iptables
chkconfig tomcat on
echo "end of script"
## customer can use service but i fix some other mistakes 
# fix init.d (output form file go to terminal)
sed -i -e 's/> \/dev\/null/ /g' /etc/init.d/tomcat
# fix other problems that i saw
sed -i 's/192.168.56.10/127.0.0.1/g' /opt/apache/tomcat/current/conf/server.xml
sed -i 's/192.168.56.10/127.0.0.1/' /etc/httpd/conf.d/workers.properties
service httpd restart
service tomcat start


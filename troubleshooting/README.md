**Report Table:**

No | Issue | How to Find | Time to find (min)| Hot to fix | Time to fix (min)
---| :---: | :---: | :---: | :---: | :---: |
1 | Site does not work | ifconfig, curl -IL 192.168.56.10 (from host) (error 302), curl -IL 192.168.56.10 (errror 302, 503)| 3  | less httpd.conf, vhosts.conf (saw 2 virtual hosts), i made comment on block VirtualHost in httpd.conf, restart httpd | 10
2 | curl -IL 192.168.56.10 (status 200), but site doesn't work | curl -IL 192.168.56.10 from host (200), from VM (200) but if curl -IL localhost (error 503), i found the error logs directory (saw in vhosts.conf) | 3| i changed (mntlab:80) to (*:80) in vhosts.conf, restart httpd | 15
3 | curl -IL 192.168.56.10 (error 503) from host | Every requests go to VirtualHost in vhosts.com, but 503 (it's backend fail), check tomcat | 10 | ps -ef  grep tomcat (not running), service tomcat start (not started)| 5
3.1 | tomcat is not starting | go to /etc/init.d/tomcat, startup.sh, catalina.sh and not found of define CATALINA_HOME | 10| switch to tomcat user, echo $CATALINA_HOME, check it from bash_profile -> bash rc, comment it, (swith to root and startup.sh) | 20
3.2 | catalina.out': Permission denied | check ls -ld /path-to-tomcat/logs (root is owner) | 5 | chown tomcat, starting tomcat | 15
3.2 | tomcat shows that started but not running | ps -ef grep tomcat, check catalina.out, find trouble with java | 20 | uname -a(arch), java -version (i understood that OS 64 bit, java 32bit), changed java version by alternatives, startup.sh, ps -ef, check netstat -natpl (tomcat listen sockets), curl from host (503), check vhost.conf, found mod_jk (log), trouble with tomcat.worker  | 60
3.3 | (tomcat.worker) connecting to tomcat failed | check worker.properties and found mistakes| 15| i corrected mistakes by sed (2 steps: ip, worker's name), restart httpd, curl from host and VM (status 200), server works, but curl -IL 192.168.56.10:8080 from host and i had status 200 from tomcat, checked iptables (iptables -L -n) -> iptables is epmty -> iptables doesn't work -> service iptables start (failed)| 30
4 | service iptables start (failed)| checked iptables (port 80 hasn't been opened) and i can't modified iptables by root | 20 | I deleted immutable flag on iptables (chattr -i), changed iptables (added input 80, include ESTABLISHED to state) through the replacement file, iptables restart,chattr +i, check curl from host 192.168.56.10:8080 (couldn't connect). restart VM | 50
5| tomcat is not running | chkconfig grep tomcat| 5| tomcat off on level 2-5, restart VM | 5

**Server works but i saw and fixsome mistakes:**

No | Issue | How to Find | Time to find (min)| Hot to fix | Time to fix (min)
---| :---: | :---: | :---: | :---: | :---: |
6 | tomcat listen 192.168.56.10|netstat -natulp|5|I changed server.xml (adress 192.168.56.10->127.0.0.1) by sed (on script) and worker.properties, restart httpd&tomcat| 15
7 | init.d/tomcat output > dev/null| less /etc/init.d/tomcat | 5| I used sed to fixed it (on script) | 20

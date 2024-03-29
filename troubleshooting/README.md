**Report Table:**

No | Issue | How to Find | Time to find (min)| Hot to fix | Time to fix (min)
---| :---: | :---: | :---: | :---: | :---: |
1 | Site does not work | ifconfig, curl -IL 192.168.56.10 (from host) (error 302), curl -IL 192.168.56.10 (errror 302, 503)| 3  | less httpd.conf, vhosts.conf (saw 2 virtual hosts), i made comment on block VirtualHost in httpd.conf, restart httpd | 10
2 | curl -IL 192.168.56.10 (status 200), but site doesn't work | curl -IL 192.168.56.10 from host (200), from VM (200) but if curl -IL localhost (error 503), i found the error logs directory (saw in vhosts.conf) | 3| I changed (mntlab:80) to (*:80) in vhosts.conf, restart httpd | 15
3 | curl -IL 192.168.56.10 (error 503) from host | Every requests go to VirtualHost in vhosts.com, but 503 (it's backend fail), check tomcat | 10 | ps -ef  grep tomcat (not running), service tomcat start (not started)| 5
3.1 | Tomcat is not starting | Go to /etc/init.d/tomcat, startup.sh, catalina.sh and not found of define CATALINA_HOME | 10| switch to tomcat user, echo $CATALINA_HOME, check it from bash_profile -> bash rc, comment it, (swith to root and startup.sh) | 20
3.2 | Catalina.out': Permission denied | check ls -ld /path-to-tomcat/logs (root is owner) | 5 | chown tomcat, starting tomcat | 15
3.2 | Tomcat shows that started but not running | ps -ef grep tomcat, check catalina.out, find trouble with java | 20 | uname -a(arch), java -version (i understood that OS 64 bit, java 32bit), changed java version by alternatives, startup.sh, ps -ef, check netstat -natpl (tomcat listen sockets), curl from host (503), check vhost.conf, found mod_jk (log), trouble with tomcat.worker  | 60
3.3 | (tomcat.worker) connecting to tomcat failed | check worker.properties and found mistakes| 15| I corrected mistakes by sed (2 steps: ip, worker's name), restart httpd, curl from host and VM (status 200), server works, but curl -IL 192.168.56.10:8080 from host and i had status 200 from tomcat, checked iptables (iptables -L -n) -> iptables is epmty -> iptables doesn't work -> service iptables start (failed)| 30
4 | service iptables start (failed)| I checked iptables (port 80 hasn't been opened) and i couldn't modify iptables by root | 20 | I deleted immutable attribute on iptables (chattr -i), changed iptables (added input 80, include ESTABLISHED to state) through the replacement file, iptables restart,chattr +i, check curl from host 192.168.56.10:8080 (couldn't connect). restart VM | 50
5| tomcat is not running | chkconfig grep tomcat| 5| chkconfig tomcat on level 2-5, restart VM | 5

**Server works but i saw and fixsome mistakes:**

No | Issue | How to Find | Time to find (min)| Hot to fix | Time to fix (min)
---| :---: | :---: | :---: | :---: | :---: |
6 | tomcat listen 192.168.56.10|netstat -natulp|5|I changed server.xml (adress 192.168.56.10->127.0.0.1) by sed (on script) and worker.properties, restart httpd&tomcat| 15
7 | init.d/tomcat output > dev/null| less /etc/init.d/tomcat | 5| I used sed to fixed it (on script) | 20

**Questions & Answers:**

**What java version is installed?**

I can check it by alternatives --config java (i see all version java which installed on this environment)
If i use command "java -version" i can see current version java

**How was it installed and configured?**

Because the java is located on /opt/oracle ...
It has been installed by rpm file and config

**Where are log files of tomcat and httpd?**

  Httpd: /var/log/httpd/  
  Tomcat: /opt/apache/tomcat/7.0.62/logs/

**Where is JAVA_HOME and what is it?**

Java_Home is the environment variable that shows point at your Java Development Kit installation.

**Where is tomcat installed?**

Tomcat installed in /opt/apache/tomcat/7.0.62/

**What is CATALINA_HOME?**

CATALINA_HOME is variable that shows point at your Catalina "build" directory (Tomcat root directory)

**What users run httpd and tomcat processes? How is it configured?**

User apache runs httpd process. It configured in /etc/httpd/conf/httpd.conf
User tomcat runs tomcat process. It configured in /etc/init.d/tomcat


**What configuration files are used to make components work with each other?**

For httpd: httpd.conf, vhost.conf, worker.properties
For Tomcat: server.xml

**What does it mean: “load average: 1.18, 0.95, 0.83”?**

This string shows avarage CPU usage per 1min, 5min, 15 min. Digit 1 means 100% lead per one core. In this example digit 1.18 means than 1st core is loaded to 100% and 2nd core is loaded to 18% (if we have more than 1 core on processor)




# Assuming we have already copied following files using a vagrant file provisioner or rsynced folders:
# ./etc/sysconfig/watchlog
# ./opt/watchlog.sh
# ./var/log/watchlog.log
# ./etc/systemd/system/watchlog.service
# ./etc/systemd/system/watchlog.timer
# ./etc/systemd/system/spawn-fcgi.service
# ./etc/sysconfig/httpd-first 
# ./etc/sysconfig/httpd-second 
# ./etc/systemd/system/httpd@.service
# ./etc/systemd/system/jira.service
# .repsonse.varfile

# First task
cp ./etc/sysconfig/watchlog /etc/sysconfig/watchlog
cp ./opt/watchlog.sh /opt/watchlog.sh
cp ./etc/systemd/system/watchlog.service /etc/systemd/system/watchlog.service
cp ./etc/systemd/system/watchlog.timer /etc/systemd/system/watchlog.timer
cp ./var/log/watchlog.log /var/log/watchlog.log
chmod +x /opt/watchlog.sh
systemctl start watchlog.timer
 
# Second task
yum install epel-release -y && yum install spawn-fcgi php php-cli mod_fcgid httpd -y
cp ./etc/systemd/system/spawn-fcgi.service /etc/systemd/system/spawn-fcgi.service
sed -i s/#OPTIONS/OPTIONS/g /etc/sysconfig/spawn-fcgi 
sed -i s/#SOCKET/SOCKET/g /etc/sysconfig/spawn-fcgi 
systemctl start spawn-fcgi.service

# Third task
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/first.conf
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/second.conf
echo "PidFile /var/run/httpd-second.pid" >> /etc/httpd/conf/second.conf
sed -i "s/Listen 80/Listen 8080 /g" /etc/httpd/conf/second.conf
cp ./etc/sysconfig/httpd-first /etc/sysconfig/httpd-first
cp ./etc/sysconfig/httpd-second /etc/sysconfig/httpd-second
cp ./etc/systemd/system/httpd@.service /etc/systemd/system/httpd@.service

systemctl start httpd@first.service
systemctl start httpd@second.service

# *Fourth task
## Install Jira from tar.gz
### install java for tomcat, wget to download jira package
yum install wget java-11-openjdk -y
### creating specific acc for running Jira
/usr/sbin/useradd --create-home --comment "Account for running Jira Software" --shell /bin/bash jira
### define some variables
export JIRA_INSTALL=/opt/atlassian/jira
export JIRA_HOME=/var/atlassian/application-data/jira
### need to add env variables to user profile, because app uses it to start
echo "export JIRA_INSTALL=/opt/atlassian/jira" >> /home/jira/.bash_profile
echo "export JIRA_HOME=/var/atlassian/application-data/jira" >> /home/jira/.bash_profile
echo "export JAVA_HOME=/bin/" >> /home/jira/.bash_profile
echo "export JRE_HOME=/bin/" >> /home/jira/.bash_profile
### setting ulimit for user jira
echo "jira hard nofile 16384" >> /etc/security/limits.conf
### making directories fix permissions
mkdir -p $JIRA_INSTALL
mkdir -p $JIRA_HOME
chown -R jira $JIRA_HOME
chmod -R u=rwx,go-rwx $JIRA_HOME
wget https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-8.20.2.tar.gz -O /tmp/atlassian-jira-software-8.20.2.tar.gz

### install app fix permission
#### unpack skipping root folder 
tar -xzf /tmp/atlassian-jira-software-8.20.2.tar.gz --strip-components=1 -C $JIRA_INSTALL
chown -R jira $JIRA_INSTALL
chmod -R u=rwx,go-rwx $JIRA_INSTALL
### configure app
#### set home dir
echo "jira.home=${JIRA_HOME}" > ${JIRA_INSTALL}/atlassian-jira/WEB-INF/classes/jira-application.properties
#### Changing port since 8080 is occupied by apache
sed -i s/8080/8888/g ${JIRA_INSTALL}/conf/server.xml

### copy service file fix perm
cp ./etc/systemd/system/jira.service /etc/systemd/system/jira.service
chmod 664 /etc/systemd/system/jira.service
### start service
systemctl start jira.service 

## Easy way to install Jira as a service

# yum install wget fontconfig -y
# wget https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-8.20.2-x64.bin
## Installer does all the work using response.varfile and launches app as a service 
# chmod a+x atlassian-jira-software-8.20.2-x64.bin 
# ./atlassian-jira-software-8.20.2-x64.bin -q -overwrite -varfile response.varfile

rm /tmp/atlassian-jira-software-8.20.2.tar.gz


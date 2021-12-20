#! /bin/bash

#install jre
cd ~&&
sudo apt-get install default-jre -y &&

#install tomcat
wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.73/bin/apache-tomcat-8.5.73.tar.gz &&
tar zxvf apache-tomcat-8.5.73.tar.gz &&
sudo mv apache-tomcat-8.5.73/ /opt/apache-tomcat-8.5.73 &&
sudo ln -s /opt/apache-tomcat-8.5.73/ /opt/tomcat8 &&
/opt/tomcat8/bin/startup.sh

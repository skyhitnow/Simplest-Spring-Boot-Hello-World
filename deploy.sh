#! /bin/bash

#install jre
cd /home/blake &&
sudo apt-get install default-jre &&

#install tomcat
wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.73/bin/apache-tomcat-8.5.73.zip &&
tar zxvf apache-tomcat-8.5.73.zip &&
sudo mv apache-tomcat-8.5.73/ /opt/apache-tomcat-8.5.73 &&
sudo ln -s /opt/apache-tomcat-8.5.73/ /opt/tomcat8 &&
/opt/tomcat8/bin/startup.sh

#!/bin/bash

# zet de keyboard layout
setxkbmap be

# Installeren van de packages
sudo apt update
sudo apt install openjdk-11-jdk -y

# Extracten van tomcat 7.0
wget https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.40/src/apache-tomcat-7.0.40-src.zip
sudo mkdir /opt/tomcat
sudo tar -xvf apache-tomcat-7*tar.gz -C /opt/tomcat --strip-components=1

# Maak een systemd service file voor tomcat

sudo touch /etc/systemd/system/tomcat.service

cat <<EOF >> /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat webs servlet container
After=network.target
[Service]
Type=forking
User=tomcat
Group=tomcat
RestartSec=10
Restart=always
Environment="JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
[Install]
WantedBy=multi-user.target
EOF

# Start tomcat service 
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat


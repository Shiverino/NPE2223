#!/bin/bash

echo "Installeren tomcat"
# Extracten van tomcat 7.0
wget https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.20/bin/apache-tomcat-7.0.20.tar.gz
mkdir /opt/tomcat
mkdir /opt/tomcat/temp
mkdir /opt/tomcat/logs
tar -xvf apache-tomcat-7*tar.gz -C /opt/tomcat --strip-components=1
chmod -R 777 /opt/tomcat/bin/catalina.sh
chmod -R 777 /opt/tomcat/bin/startup.sh
chmod -R 777 /opt/tomcat/bin/shutdown.sh

echo "extracting done"
# Maak een systemd service file voor tomcat
touch /etc/systemd/system/tomcat.service
cat <<EOF >> /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat webs servlet container
After=network.target
[Service]
Type=oneshot
RestartSec=10
RemainAfterExit=yes
Environment="JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64"
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
echo "system.d file gemaakt"
# Deploy java web-applicatie op tomcat
echo "Deploying web-applicatie"
wget https://github.com/rapid7/metasploit-framework/files/712278/sample-multipart-form.zip
unzip sample-multipart-form.zip && cd sample-multipart-form
cp target/sample-multipart-form.war /opt/tomcat/webapps/

# Static IP geven aan interface intnet

# Interface en IP-adres dat je wilt configureren
interface="eth1"
ip_address="192.168.0.105"
subnet_mask="255.255.255.0"
gateway="192.168.0.1"


# Wijzig de netwerkconfiguratie
cat << EOF > /etc/network/interfaces

source  /etc/network/interfaces.d/*

auto lo
iface lo inet loopback

$interface
iface $interface inet static
    address $ip_address
    netmask $subnet_mask
    gateway $gateway
EOF
# Restart networking service
sudo /etc/init.d/networking restart

# Start tomcat service 
systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat



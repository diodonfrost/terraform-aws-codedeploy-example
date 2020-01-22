#!/bin/bash

apt-get update
apt-get install -y apache2 ruby wget
systemctl enable apache2
systemctl start apache2
rm -f /var/www/html/index.html
wget https://aws-codedeploy-eu-west-1.s3.eu-west-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
systemctl enable codedeploy-agent
systemctl start codedeploy-agent

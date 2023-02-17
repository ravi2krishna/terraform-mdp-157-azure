#!/bin/bash
sudo apt-get -y update
sudo apt-get -y install apache2
sudo systemctl start apache2
sudo systemctl enable apache2
sudo apt-get -y install git
sudo rm /var/www/html/index.html
sudo git clone https://github.com/ravi2krishna/ecomm.git /var/www/html
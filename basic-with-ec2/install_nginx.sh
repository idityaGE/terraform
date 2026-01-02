#!/bin/bash

sudo apt update
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
sudo ufw allow 'Nginx HTTP'

echo "<h1>Welcome to Nginx | Localstack</h1>" | sudo tee /var/www/html/index.html
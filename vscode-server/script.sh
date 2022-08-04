#!/bin/bash
apt update
apt upgrade -y
# install nginx
apt install -y nginx
# set nginx setting
touch /etc/nginx/sites-available/code-server
echo "server {
    listen 80;
    listen [::]:80;
    server_name ~^.*\$;

    location / {
        proxy_pass http://localhost:8080/;
        proxy_set_header Host \$host;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection upgrade;
        proxy_set_header Accept-Encoding gzip;
    }
}" | tee -a /etc/nginx/sites-available/code-server
ln -s /etc/nginx/sites-available/code-server /etc/nginx/sites-enabled/code-server
systemctl restart nginx
# Ubuntu 22.04 EC2 dafault user is "ubuntu"
runuser ubuntu -c "curl -fsSL https://code-server.dev/install.sh | sh"
runuser ubuntu -c "sudo systemctl enable --now code-server@ubuntu"
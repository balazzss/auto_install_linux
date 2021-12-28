#!/bin/sh

sudo apt install curl -y
sudo groupadd --system prometheus
sudo useradd -s /sbin/nologin --system -g prometheus prometheus
curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest| grep browser_download_url|grep linux-amd64|cut -d '"' -f 4|wget -qi -
tar -xvf node_exporter*.tar.gz
sudo rm -r node_exporter*.tar.gz
sudo cp node_exporter*/node_exporter /usr/local/bin

sudo tee /etc/systemd/system/node_exporter.service <<EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
EOF

sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

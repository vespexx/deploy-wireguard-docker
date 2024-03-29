#!/bin/sh

sudo apt update \
  && sudo useradd -s /bin/bash -u 1337 -G sudo -m usernamewg
#  && passwd usernamewg

sudo apt upgrade -y 

echo '>'
echo '>sudo apt install docker.io docker-compose -y'
sudo apt install docker.io docker-compose -y
#curl https://get.docker.com -o install.sh && sudo sh install.sh

echo '>'
echo '>docker-compose --version'
docker-compose --version

sudo gpasswd -a usernamewg docker

#nano docker-compose.yml

echo '>'
echo '>cat << EOF > /app/vpn/wireguard/docker-compose.yml'
cat << EOF > /app/vpn/wireguard/docker-compose.yml
---
version: "2.1"
services:
  wireguard:
    image: ghcr.io/linuxserver/wireguard
    container_name: wireguard
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    environment:
      - PUID=1337
      - PGID=1337
      - TZ=Europe/Moscow
      - SERVERURL=auto #optional
      - SERVERPORT=444 #optional
      - PEERS=10 #optional
      - PEERDNS=auto #optional
      - INTERNAL_SUBNET=10.40.40.0 #optional
      - ALLOWEDIPS=0.0.0.0/0 #optional
    volumes:
      - ~/wireguard/config:/config
      - /lib/modules:/lib/modules
    ports:
      - 444:51820/udp
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
    restart: always
EOF

echo '>'
echo '>docker-compose -f /app/vpn/wireguard/docker-compose.yml up -d'
sudo -H -u usernamewg docker-compose -f /app/vpn/wireguard/docker-compose.yml up -d

echo '>'
echo '>docker ps'

docker ps

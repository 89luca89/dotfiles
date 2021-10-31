#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

echo 'max_usb_current=1' | tee -a /boot/config.txt

apt update; apt upgrade -y
apt install -y \
    cryptsetup \
    htop \
    iftop \
    iotop \
    lm-sensors \
    nginx \
    parallel \
    rclone \
    rsync \
    tmux \
    vim

yes | sensors-detect

sed -i 's/^.*PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart sshd

ln -s /usr/local/mnt/Vault/Syncthing/bin /root/bin
ln -s /usr/local/mnt/Vault/Syncthing/conf/.rclone.conf ~/

pip3 install docker-compose
curl -sSL https://get.docker.com | sh
systemctl status docker
cd ~/docker/
docker compose up -d

crontab ~/docker/crontab.backup
ln -s ~/docker/data/nginx/*.conf /etc/nginx/sites-enabled/

cat ~/docker/hosts >> /etc/hosts

userdel pi

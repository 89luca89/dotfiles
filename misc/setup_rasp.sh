#!/bin/sh

set -o errexit
set -o nounset

apt update
apt upgrade -y

echo 'max_usb_current=1' | tee -a /boot/config.txt

apt install -y cryptsetup iotop htop iftop tmux vim lm-sensors

yes | sensors-detect

sed -i 's/^.*PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart sshd

echo '#!/bin/sh

        if ! ls /dev/mapper/secret; then
        cryptsetup luksOpen /dev/sda1 secret --key-file /root/lukskey-disk
        mount /dev/mapper/secret /usr/local/mnt/Vault
        cd /root/docker
        docker-compose down
        docker-compose up -d
else
        if ! df | grep -q Vault; then
                mount /dev/mapper/secret /usr/local/mnt/Vault
                cd /root/docker
                docker-compose down
                docker-compose up -d
        fi
fi' | tee /root/mount.sh
chmod +x /root/mount.sh

ln -s /usr/local/mnt/Vault/Syncthing/Bin /root/bin

apt install -y stunnel
ln -sf /bin/bash /bin/rbash
echo /bin/rbash >>/etc/shells

userdel pi

useradd -s /usr/bin/rbash -U stunnel
mkdir /home/stunnel
rsync -av --progress /usr/local/mnt/Vault/Syncthing/Secured/Stunnel-Server /home/stunnel/Stunnel-Server
chown -R stunnel.stunnel /home/stunnel/

echo '
[Unit]
Description=SSL tunnel for network daemons
After=network.target
After=syslog.target

[Install]
WantedBy=multi-user.target
Alias=stunnel.target

[Service]
User=stunnel
Group=stunnel
Type=forking
ExecStart=/usr/bin/stunnel /home/stunnel/Stunnel-Server/stunnel.conf
ExecStop=/usr/bin/killall -9 stunnel

# Give up if ping dont get an answer
TimeoutSec=600

Restart=always
PrivateTmp=false' | tee /etc/systemd/system/stunnel-custom.service

pip3 install "glances[all]"

echo '
[Unit]
Description = Glances in Web Server Mode
After = network.target

[Service]
ExecStart = /usr/local/bin/glances  -w  -t  5 -1

[Install]
WantedBy = multi-user.target' | tee /etc/systemd/system/glances.service

apt install rclone -y
ln -s /usr/local/mnt/Vault/Syncthing/Conf/.rclone.conf ~/

pip3 install docker-compose
curl -sSL https://get.docker.com | sh
systemctl status docker
cd ~/docker/
docker compose up -d

crontab /usr/local/mnt/Vault/Syncthing/Conf/crontab.cron

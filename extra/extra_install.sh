#/bin/bash

apt install -y bash-completion
apt install -y sudo
apt install -y usbutils 
apt install -y net-tools 
apt install -y iputils-ping 
apt install -y network-manager
apt install -y vim
apt install -y openssh-server 
apt install -y kmod
apt install -y bluez-tools 
apt install -y bluez
apt install -y locales
apt install -y language-pack-en-base 
apt install -y curl wget
apt install -y iperf
apt install -y i2c-tools 
apt install -y parted
apt install -y dosfstools 
apt install -y landscape-common

if [ -f /usr/lib/NetworkManager/conf.d/10-globally-managed-devices.conf ]; then
    cp 10-globally-managed-devices.conf /usr/lib/NetworkManager/conf.d/10-globally-managed-devices.conf
fi


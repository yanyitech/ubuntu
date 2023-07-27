#/bin/bash

apt install -f -y
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
apt install -y curl wget
apt install -y iperf
apt install -y i2c-tools 
apt install -y parted
apt install -y dosfstools 
apt install -y software-properties-common

if [ -f /usr/lib/NetworkManager/conf.d/10-globally-managed-devices.conf ]; then
    cp 10-globally-managed-devices.conf /usr/lib/NetworkManager/conf.d/10-globally-managed-devices.conf
fi

SYS_VER=`lsb_release -i | awk '{print $3}'`
ARCH_MAC=`uname -m`
if [ "x$SYS_VER" = "xUbuntu" -a "x$ARCH_MAC" = "xaarch64" ]; then
    echo "Ubuntu OS ARM64"
    echo -e '\n' | add-apt-repository ppa:george-coolpi/mali-g610
    echo -e '\n' | add-apt-repository ppa:george-coolpi/multimedia
    echo -e '\n' | add-apt-repository ppa:george-coolpi/rknpu

    apt update
    apt install -y language-pack-en-base
    apt install -y landscape-common
    apt install -y mpv
    apt install -y qv4l2
    apt install -y camera-engine-rkaiq
    apt install -y gstreamer1.0-plugins-good
    apt install -y gstreamer1.0-plugins-bad
    apt install -y gstreamer1.0-plugins-ugly
    apt install -y gstreamer1.0-rockchip
    apt install -y rknpu2
fi

if [ "x$SYS_VER" = "xUbuntu" -a "x$ARCH_MAC" = "xx86_64" ]; then
    echo "Ubuntu OS X86_64"
    #for compile u-boot
    apt install -y gcc make device-tree-compiler python2
    apt install -y git file
fi

if [ "x$SYS_VER" = "xDebian" ]; then
    echo "Debian OS"
fi

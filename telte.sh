#!/bin/bash -e
TARGET_ROOTFS_DIR="temp"
KERNEL_FOLDER_NEAM="coolpi-kernel"
KERNEL_BRANCH_NEAM="develop"
ROOTFS_IMG_SIZE=8192
KERNEL_GIT_ADD="https://github.com/yanyitech/coolpi-kernel.git"
export LC_ALL="C"
if [ -e $TARGET_ROOTFS_DIR ]; then
	sudo rm -rf $TARGET_ROOTFS_DIR -R
fi
echo "welcome coolpi-4b ubuntu image make"
echo "1.ubuntu22.04 desktop"
echo "2.ubuntu20.04 desktop"
echo "3.ubuntu18.04 desktop"
echo "4.退出."
read -p "请输入[1-4]:" key
case $key in
1)ROOTFS_VERSION="22.04";;
2)ROOTFS_VERSION="20.04.5";;
3)ROOTFS_VERSION="18.04.5";;
4)exit
esac
ROOTFS_IMG_NEAM="$(date "+%Y%m%d")-ubuntu-${ROOTFS_VERSION}-preinstalled-desktop-arm64-coolpi.img"
echo $ROOTFS_IMG_NEAM
echo "#####start download base package#####"  
if [ ! -e ./source/ubuntu-base-$ROOTFS_VERSION-base-arm64.tar.gz ]; then
	wget https://cdimage.ubuntu.com/ubuntu-base/releases/$ROOTFS_VERSION/release/ubuntu-base-$ROOTFS_VERSION-base-arm64.tar.gz -P ./source
fi
echo "mkdir temp"
mkdir $TARGET_ROOTFS_DIR
sudo tar -xpf ./source/ubuntu-base-$ROOTFS_VERSION-base-arm64.tar.gz -C $TARGET_ROOTFS_DIR
echo "#####start download kernel source code#####" 
if [ -e ./source/$KERNEL_FOLDER_NEAM ]; then
	cd ./source/coolpi-kernel
	git checkout $KERNEL_BRANCH_NEAM
	cd ../../
else
	cd ./source
	git clone $KERNEL_GIT_ADD
	cd ../
fi 
echo "#####start build boot image#####"
cd ./source/coolpi-kernel
./build-kernel.sh
sudo ./build-fatboot.sh
cd ../../
echo "#####copy resolv.conf#####"
sudo cp -b /etc/resolv.conf temp/etc/
echo "#####copy qemu-aarch64-static#####"
sudo cp /usr/bin/qemu-aarch64-static temp/usr/bin/
sudo mount -o bind /dev $TARGET_ROOTFS_DIR/dev
sudo mount -o bind /proc $TARGET_ROOTFS_DIR/proc
echo "#####start chroot#####"
cat <<EOF | sudo chroot $TARGET_ROOTFS_DIR
echo Ubuntu > /etc/hostname
echo 127.0.0.1 localhost > /etc/hosts
echo 127.0.0.1 Ubuntu >> /etc/hosts
apt-get update
apt-get install apt-utils rsyslog dialog perl locales sudo systemd kmod pkg-config ifupdown net-tools ethtool udev wireless-tools iputils-ping resolvconf wget  wpasupplicant nano vim sshfs openssh-server bash-completion  busybox netplan.io samba libdrm-dev wayland-protocols libwayland-dev libx11-xcb-dev  -y
apt-get update
apt-get install -f
apt-get install ubuntu-desktop -y 
apt-get install mpv -y
apt-get remove totem -y
apt-get autoremove -y
apt-get update
apt-get upgrade -y
add-apt-repository ppa:liujianfeng1994/panfork-mesa
add-apt-repository ppa:liujianfeng1994/rockchip-multimedia
apt update
apt dist-upgrade -y
exit
EOF
sudo umount ./$TARGET_ROOTFS_DIR/dev
sudo umount ./$TARGET_ROOTFS_DIR/proc
echo -e "network:\n  ethernets:\n    eth0:\n      dhcp4: yes\n      dhcp6: yes\n    eth1:\n      dhcp4: yes\n      dhcp6: yes\n  version: 2\n  renderer: NetworkManager" | sudo tee $TARGET_ROOTFS_DIR/etc/netplan/01-network-manager-all.yaml
sudo cp -rfp ./bin/gpu/mali_csffw.bin ./$TARGET_ROOTFS_DIR/lib/firmware/
sudo cp -rfp ./bin/init/rc.local  ./$TARGET_ROOTFS_DIR/etc/
sudo cp -rfp ./bin/wifi/ap6256/brcm_patchram_plus1  ./$TARGET_ROOTFS_DIR/usr/bin/
sudo tar -zxvf ./bin/wifi/aic8800/aic8800.tar.gz -C ./$TARGET_ROOTFS_DIR/lib/firmware/
sudo tar -zxvf ./bin/wifi/ap6256/ap6256.tar.gz -C ./$TARGET_ROOTFS_DIR/lib/firmware/
sudo tar -zxvf ./source/coolpi-kernel/out/modules.tar.gz -C ./$TARGET_ROOTFS_DIR/lib
echo "#####start dd img#####"
dd if=/dev/zero of=./output/$ROOTFS_IMG_NEAM bs=1M count=$ROOTFS_IMG_SIZE
echo "#####start parted#####"
printf 'n\np\n1\n32768\n1081343\nn\np\n2\n1081344\n16777215\nw\n' | fdisk ./output/$ROOTFS_IMG_NEAM
printf 't\n1\n0b\nw\n' | fdisk ./output/$ROOTFS_IMG_NEAM
LOOP_NUMBER=$(lsblk |grep -o  "loop.." |awk  '{print $1}'|tail -2| grep -o '[[:digit:]]\+')
echo LOOP_NUMBER=$LOOP_NUMBER
LOOP_NUMBER=$[$LOOP_NUMBER+1] 
echo LOOP_NUMBER=$LOOP_NUMBER
sudo partx -a -v ./output/$ROOTFS_IMG_NEAM
sudo mkfs.vfat /dev/"loop"${LOOP_NUMBER}"p1"
echo 'yes\n' | sudo mkfs.ext4 /dev/loop${LOOP_NUMBER}p2
sudo dd if=./source/coolpi-kernel/coolpi-boot.img of=/dev/loop${LOOP_NUMBER}p1
sudo rm -rf ./rootfs/* -R
sudo mkdir ./rootfs
sudo mount /dev/loop${LOOP_NUMBER}p2 ./rootfs
sudo cp -rfp ./temp/* ./rootfs -R
sudo umount ./rootfs
sudo e2fsck  -p -f /dev/loop${LOOP_NUMBER}p2
sudo resize2fs -M /dev/loop${LOOP_NUMBER}p2
sudo e2label /dev/loop${LOOP_NUMBER}p2 writable
sudo losetup -d /dev/loop${LOOP_NUMBER}
fdisk -l ./output/$ROOTFS_IMG_NEAM
echo "#####ubuntu img creat ok#####"
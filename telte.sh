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
2)ROOTFS_VERSION="20.04";;
3)ROOTFS_VERSION="18.04";;
4)exit
esac
ROOTFS_IMG_NEAM="$(date "+%Y%m%d")-ubuntu-${ROOTFS_VERSION}-preinstalled-desktop-arm64-coolpi.img"
echo $ROOTFS_IMG_NEAM
echo "#####start download base package#####"  
if [ -e ubuntu-base-$ROOTFS_VERSION-base-arm64.tar.gz ]; then
	sudo rm -rf ubuntu-base-$ROOTFS_VERSION-base-arm64.tar.gz
fi
wget https://cdimage.ubuntu.com/ubuntu-base/releases/$ROOTFS_VERSION/release/ubuntu-base-$ROOTFS_VERSION-base-arm64.tar.gz
echo "mkdir temp"
mkdir $TARGET_ROOTFS_DIR
sudo tar -xpf ubuntu-base-$ROOTFS_VERSION-base-arm64.tar.gz -C $TARGET_ROOTFS_DIR
echo "#####start download kernel source code#####" 
if [ -e $KERNEL_FOLDER_NEAM ]; then
	cd coolpi-kernel
	git checkout $KERNEL_BRANCH_NEAM
	cd ../
else
	git clone $KERNEL_GIT_ADD
fi 
echo "#####start build boot image#####"
cd coolpi-kernel
./build-kernel.sh
sudo ./build-fatboot.sh
cd ../
echo "#####copy resolv.conf#####"
sudo cp -b /etc/resolv.conf temp/etc/
echo "#####copy qemu-aarch64-static#####"
sudo cp /usr/bin/qemu-aarch64-static temp/usr/bin/
sudo mount -o bind /dev $TARGET_ROOTFS_DIR/dev
echo "#####start chroot#####"
cat <<EOF | sudo chroot $TARGET_ROOTFS_DIR
useradd -G sudo -m -s /bin/bash coolpi
echo coolpi:123 | chpasswd
echo Ubuntu > /etc/hostname
echo 127.0.0.1 localhost > /etc/hosts
echo 127.0.0.1 Ubuntu >> /etc/hosts
apt-get update
apt-get install apt-utils rsyslog dialog perl locales sudo systemd kmod pkg-config ifupdown net-tools ethtool udev wireless-tools iputils-ping resolvconf wget  wpasupplicant nano vim sshfs openssh-server bash-completion  busybox netplan.io samba libdrm-dev wayland-protocols libwayland-dev libx11-xcb-dev  -y
apt-get update
apt-get install -f
apt-get install ubuntu-desktop mpv sudo -y
apt-get remove totem -y
apt-get autoremove -y
apt-get update
apt-get upgrade -y
mkdir /home/coolpi/share
chown coolpi:coolpi /home/coolpi/share -R
chmod 777 /home/coolpi/share -R
mkdir -p /system/lib
add-apt-repository ppa:liujianfeng1994/panfork-mesa
add-apt-repository ppa:liujianfeng1994/rockchip-multimedia
apt update
apt dist-upgrade -y
exit
EOF
sudo umount ./$TARGET_ROOTFS_DIR/dev
echo -e "[share]\ncomment = samba\npath = /home/coolpi/share\npublic = yes\nwritable = yes\ncreate mask = 0644\ndirectory mask = 0755" | sudo tee $TARGET_ROOTFS_DIR/etc/samba/smb.conf
echo -e "network:\n  ethernets:\n    eth0:\n      dhcp4: yes\n      dhcp6: yes\n    eth1:\n      dhcp4: yes\n      dhcp6: yes\n  version: 2\n  renderer: NetworkManager" | sudo tee $TARGET_ROOTFS_DIR/etc/netplan/01-network-manager-all.yaml
sudo cp -rfp ./mali_csffw.bin ./$TARGET_ROOTFS_DIR/lib/firmware/
sudo cp -rfp ./rc.local  ./$TARGET_ROOTFS_DIR/etc/
sudo tar -zxvf ./aic8800.tar.gz -C ./$TARGET_ROOTFS_DIR/lib/firmware/
sudo tar -zxvf ./coolpi-kernel/out/modules.tar.gz -C ./$TARGET_ROOTFS_DIR/system/lib
echo "#####start dd img#####"
dd if=/dev/zero of=$ROOTFS_IMG_NEAM bs=1M count=$ROOTFS_IMG_SIZE
echo "#####start parted#####"
printf 'n\np\n1\n32768\n1081343\nn\np\n2\n1081344\n16777215\nw\n' | fdisk $ROOTFS_IMG_NEAM
printf 't\n1\n0b\nw\n' | fdisk $ROOTFS_IMG_NEAM
LOOP_NUMBER=$(lsblk |grep -o  "loop.." |awk  '{print $1}'|tail -2| grep -o '[[:digit:]]\+')
echo LOOP_NUMBER=$LOOP_NUMBER
LOOP_NUMBER=$[$LOOP_NUMBER+1] 
echo LOOP_NUMBER=$LOOP_NUMBER
sudo partx -a -v $ROOTFS_IMG_NEAM
sudo mkfs.vfat /dev/"loop"${LOOP_NUMBER}"p1"
echo 'yes\n' | sudo mkfs.ext4 /dev/loop${LOOP_NUMBER}p2
sudo dd if=./coolpi-kernel/coolpi-boot.img of=/dev/loop${LOOP_NUMBER}p1
sudo rm -rf ./rootfs/* -R
sudo mount /dev/loop${LOOP_NUMBER}p2 ./rootfs
sudo cp -rfp ./temp/* ./rootfs -R
sudo umount ./rootfs
sudo e2fsck  -p -f /dev/loop${LOOP_NUMBER}p2
sudo resize2fs -M /dev/loop${LOOP_NUMBER}p2
sudo e2label /dev/loop${LOOP_NUMBER}p2 writable
sudo losetup -d /dev/loop${LOOP_NUMBER}
fdisk -l $ROOTFS_IMG_NEAM
echo "#####ubuntu img creat ok#####"
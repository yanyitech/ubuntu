#!/bin/bash
#support: www.cool-pi.com

#sudo apt install binfmt-support qemu-user-static debootstrap wget

TOPDIR=`pwd`

clear
echo "***************************************************"
cat << EOF
Select Ubuntu or Debian Version:
    1. Ubuntu18.04 32bit armhf
    2. Ubuntu18.04 64bit arm64
    3. Ubuntu20.04 32bit armhf
    4. Ubuntu20.04 64bit arm64
    5. Ubuntu22.04 32bit armhf
    6. Ubuntu22.04 64bit arm64
    7. Ubuntu23.04 32bit armhf
    8. Ubuntu23.04 64bit arm64
    9. Debian12 32bit armhf
   10. Debian12 64bit arm64
   11. Debian11 32bit armhf
   12. Debian11 64bit arm64
   13. Debian10 32bit armhf
   14. Debian10 64bit arm64
   15. Ubuntu22.04 64bit amd64
   16. Ubuntu20.04 64bit amd64
   17. Ubuntu18.04 64bit amd64
   q. Quit
EOF
read -r -p "Which version select[1-17]: " opt
case $opt in
1)
    export ARCH="armhf"
    export VER_UBUNTU="18.04.5"
    export VER_SUM="09730a1dfe882f6e81c983d3deb10a9a"
    export QEMU_BIN="/usr/bin/qemu-arm-static"
    export VER_CODE="bionic"
    export ROOTFS=$TOPDIR/rootfs_ubuntu_${VER_UBUNTU}_${ARCH}
    export DOWNLOAD_TAR="ubuntu-base-${VER_UBUNTU}-base-${ARCH}.tar.gz"
    export CUSTOM_TAR="ubuntu-base-${VER_UBUNTU}-custom-${ARCH}.tar.gz"
    ;;
2)
    export ARCH="arm64"
    export VER_UBUNTU="18.04.5"
    export VER_SUM="5daeef877b716438584db842e49ff1e9"
    export QEMU_BIN="/usr/bin/qemu-aarch64-static"
    export VER_CODE="bionic"
    export ROOTFS=$TOPDIR/rootfs_ubuntu_${VER_UBUNTU}_${ARCH}
    export DOWNLOAD_TAR="ubuntu-base-${VER_UBUNTU}-base-${ARCH}.tar.gz"
    export CUSTOM_TAR="ubuntu-base-${VER_UBUNTU}-custom-${ARCH}.tar.gz"
    ;;
3)
    export ARCH="armhf"
    export VER_UBUNTU="20.04.5"
    export VER_SUM="16aacbdc2700bb3a9eceb2bb04668a7a"
    export QEMU_BIN="/usr/bin/qemu-arm-static"
    export VER_CODE="focal"
    export ROOTFS=$TOPDIR/rootfs_ubuntu_${VER_UBUNTU}_${ARCH}
    export DOWNLOAD_TAR="ubuntu-base-${VER_UBUNTU}-base-${ARCH}.tar.gz"
    export CUSTOM_TAR="ubuntu-base-${VER_UBUNTU}-custom-${ARCH}.tar.gz"
    ;;
4)
    export ARCH="arm64"
    export VER_UBUNTU="20.04.5"
    export VER_SUM="a207a1a6ecdaec5a165cbae3daac83a6"
    export QEMU_BIN="/usr/bin/qemu-aarch64-static"
    export VER_CODE="focal"
    export ROOTFS=$TOPDIR/rootfs_ubuntu_${VER_UBUNTU}_${ARCH}
    export DOWNLOAD_TAR="ubuntu-base-${VER_UBUNTU}-base-${ARCH}.tar.gz"
    export CUSTOM_TAR="ubuntu-base-${VER_UBUNTU}-custom-${ARCH}.tar.gz"
    ;;
5)
    export ARCH="armhf"
    export VER_UBUNTU="22.04.2"
    export VER_SUM="2b45cd48b94d3fe89624e4a4e238ef0f"
    export QEMU_BIN="/usr/bin/qemu-arm-static"
    export VER_CODE="jammy"
    export ROOTFS=$TOPDIR/rootfs_ubuntu_${VER_UBUNTU}_${ARCH}
    export DOWNLOAD_TAR="ubuntu-base-${VER_UBUNTU}-base-${ARCH}.tar.gz"
    export CUSTOM_TAR="ubuntu-base-${VER_UBUNTU}-custom-${ARCH}.tar.gz"
    ;;
6)
    export ARCH="arm64"
    export VER_UBUNTU="22.04.2"
    export VER_SUM="ad795d8ef6da675ad7571e1b0d1c090a"
    export QEMU_BIN="/usr/bin/qemu-aarch64-static"
    export VER_CODE="jammy"
    export ROOTFS=$TOPDIR/rootfs_ubuntu_${VER_UBUNTU}_${ARCH}
    export DOWNLOAD_TAR="ubuntu-base-${VER_UBUNTU}-base-${ARCH}.tar.gz"
    export CUSTOM_TAR="ubuntu-base-${VER_UBUNTU}-custom-${ARCH}.tar.gz"
    ;;
7)
    export ARCH="armhf"
    export VER_UBUNTU="23.04"
    export VER_SUM="f24f0fc28a8ca015d30203b34a60113a"
    export QEMU_BIN="/usr/bin/qemu-arm-static"
    export VER_CODE="jammy"
    export ROOTFS=$TOPDIR/rootfs_ubuntu_${VER_UBUNTU}_${ARCH}
    export DOWNLOAD_TAR="ubuntu-base-${VER_UBUNTU}-base-${ARCH}.tar.gz"
    export CUSTOM_TAR="ubuntu-base-${VER_UBUNTU}-custom-${ARCH}.tar.gz"
    ;;
8)
    export ARCH="arm64"
    export VER_UBUNTU="23.04"
    export VER_SUM="00fb4cd923edf2b7efa18b038af0dc70"
    export QEMU_BIN="/usr/bin/qemu-aarch64-static"
    export VER_CODE="lunar"
    export ROOTFS=$TOPDIR/rootfs_ubuntu_${VER_UBUNTU}_${ARCH}
    export DOWNLOAD_TAR="ubuntu-base-${VER_UBUNTU}-base-${ARCH}.tar.gz"
    export CUSTOM_TAR="ubuntu-base-${VER_UBUNTU}-custom-${ARCH}.tar.gz"
    ;;
9)
    export ARCH="armhf"
    export VER_CODE="bookworm"
    export QEMU_BIN="/usr/bin/qemu-arm-static"
    export VER_DEBIAN="12"
    export ROOTFS=$TOPDIR/rootfs_debian_${VER_CODE}_${ARCH}
    export CUSTOM_TAR="debian-base-${VER_DEBIAN}-custom-${ARCH}.tar.gz"
    #export MIRROR_SERVER="http://ftp.cn.debian.org/debian"
    export MIRROR_SERVER="https://mirrors.ustc.edu.cn/debian"
    ;;
10)
    export ARCH="arm64"
    export VER_CODE="bookworm"
    export QEMU_BIN="/usr/bin/qemu-aarch64-static"
    export VER_DEBIAN="12"
    export ROOTFS=$TOPDIR/rootfs_debian${VER_DEBIAN}_${VER_CODE}_${ARCH}
    export CUSTOM_TAR="debian-base-${VER_DEBIAN}-custom-${ARCH}.tar.gz"
    #export MIRROR_SERVER="http://ftp.cn.debian.org/debian"
    export MIRROR_SERVER="https://mirrors.ustc.edu.cn/debian"
    ;;
11)
    export ARCH="armhf"
    export VER_CODE="bullseye"
    export QEMU_BIN="/usr/bin/qemu-arm-static"
    export VER_DEBIAN="11"
    export ROOTFS=$TOPDIR/rootfs_debian${VER_DEBIAN}_${VER_CODE}_${ARCH}
    export CUSTOM_TAR="debian-base-${VER_DEBIAN}-custom-${ARCH}.tar.gz"
    export MIRROR_SERVER="https://mirrors.ustc.edu.cn/debian"
    ;;
12)
    export ARCH="arm64"
    export VER_CODE="bullseye"
    export QEMU_BIN="/usr/bin/qemu-aarch64-static"
    export VER_DEBIAN="11"
    export ROOTFS=$TOPDIR/rootfs_debian${VER_DEBIAN}_${VER_CODE}_${ARCH}
    export CUSTOM_TAR="debian-base-${VER_DEBIAN}-custom-${ARCH}.tar.gz"
    export MIRROR_SERVER="https://mirrors.ustc.edu.cn/debian"
    ;;
13)
    export ARCH="arm"
    export VER_CODE="buster"
    export QEMU_BIN="/usr/bin/qemu-arm-static"
    export VER_DEBIAN="10"
    export ROOTFS=$TOPDIR/rootfs_debian${VER_DEBIAN}_${VER_CODE}_${ARCH}
    export CUSTOM_TAR="debian-base-${VER_DEBIAN}-custom-${ARCH}.tar.gz"
    export MIRROR_SERVER="https://mirrors.ustc.edu.cn/debian"
    ;;
14)
    export ARCH="arm64"
    export VER_CODE="buster"
    export QEMU_BIN="/usr/bin/qemu-aarch64-static"
    export VER_DEBIAN="10"
    export ROOTFS=$TOPDIR/rootfs_debian_${VER_CODE}_${ARCH}
    export CUSTOM_TAR="debian-base-${VER_DEBIAN}-custom-${ARCH}.tar.gz"
    export MIRROR_SERVER="https://mirrors.ustc.edu.cn/debian"
    ;;
15)
    export ARCH="amd64"
    export VER_UBUNTU="22.04.2"
    export VER_SUM="1b1fa7f402ece1ead88a7bd406669be3"
    export QEMU_BIN="/usr/bin/qemu-x86_64-static"
    export VER_CODE="jammy"
    export ROOTFS=$TOPDIR/rootfs_ubuntu_${VER_UBUNTU}_${ARCH}
    export DOWNLOAD_TAR="ubuntu-base-${VER_UBUNTU}-base-${ARCH}.tar.gz"
    export CUSTOM_TAR="ubuntu-base-${VER_UBUNTU}-custom-${ARCH}.tar.gz"
    ;;
16)
    export ARCH="amd64"
    export VER_UBUNTU="20.04.5"
    export VER_SUM="be0777779f01814b785ea7881f733719"
    export QEMU_BIN="/usr/bin/qemu-x86_64-static"
    export VER_CODE="jammy"
    export ROOTFS=$TOPDIR/rootfs_ubuntu_${VER_UBUNTU}_${ARCH}
    export DOWNLOAD_TAR="ubuntu-base-${VER_UBUNTU}-base-${ARCH}.tar.gz"
    export CUSTOM_TAR="ubuntu-base-${VER_UBUNTU}-custom-${ARCH}.tar.gz"
    ;;
17)
    export ARCH="amd64"
    export VER_UBUNTU="18.04.5"
    export VER_SUM="43ebc182ae8174b006b42d4f14e480a9"
    export QEMU_BIN="/usr/bin/qemu-x86_64-static"
    export VER_CODE="jammy"
    export ROOTFS=$TOPDIR/rootfs_ubuntu_${VER_UBUNTU}_${ARCH}
    export DOWNLOAD_TAR="ubuntu-base-${VER_UBUNTU}-base-${ARCH}.tar.gz"
    export CUSTOM_TAR="ubuntu-base-${VER_UBUNTU}-custom-${ARCH}.tar.gz"
    ;;
[qQ])
    exit 0
    ;;
*)
    echo "Invalid option. Exit Now."
    exit 1
    ;;
esac

echo "***************************************************"
cat << EOF
Select rebuild or update root filesystem:
    1. Clean and rebuild
    2. Only mount and enter
    3. Quit
EOF
read -r -p "Which Operate select[1-3]: " opt
case $opt in
1)
    OPS="rebuild"	
    ;;
2)
    OPS="update"
    ;;
3)
    exit 0
    ;;
*)
    exit 1
esac
 
trap step_exit INT

step_exit()
{
    #logout
    sudo umount -lf $ROOTFS/dev/pts
    sudo umount -lf $ROOTFS/dev
    sudo umount $ROOTFS/sys
    sudo umount $ROOTFS/proc
    if [ ! -z $QEMU_BIN ]; then
        sudo rm -f $ROOTFS/$QEMU_BIN
    fi
    sudo rm -rf $ROOTFS/root/extra

    read -r -p "Regenerate rootfs tarball?(Y/N)" opt
    case $opt in
    [yY][eE][sS]|[yY])
        sel="yes"
        ;;
    [nN][oO]|[nN])
        sel="no"
        ;;
    *)
        echo "Invalid option.Use Default Yes."
        sel="yes"
        ;;
    esac
    
    if [ $sel == "yes" ]; then
        cd $ROOTFS
        sudo tar -czf ${CUSTOM_TAR} *
        sudo mv -f ${CUSTOM_TAR} ../
    fi
}

step_auto_install()
{
    sudo cp -a extra $ROOTFS/root
    sudo cp -a $QEMU_BIN $ROOTFS/usr/bin
    sudo mount -t proc proc $ROOTFS/proc
    sudo mount -t sysfs sysfs $ROOTFS/sys
    sudo mount --bind /dev $ROOTFS/dev
    sudo mount --bind /dev/pts $ROOTFS/dev/pts
    HOME=/root sudo chroot $ROOTFS /bin/bash << "EOT"
    cd ~

    apt update
    apt install -f -y
    apt install -y sudo
   
    cat << EOF > /etc/apt/apt.conf.d/10periodic
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Download-Upgradeable-Packages "0";
APT::Periodic::AutocleanInterval "0";
EOF

    adduser -q --disabled-password --gecos "" coolpi
    usermod -aG sudo coolpi
    usermod -p '$y$j9T$PjbenLFFdUtqQtA4PwV6j.$kyBloe9JwsWQYGWb9aP4cXR5Rg.I1Y8NrMD0wnCg.x9' coolpi

    echo "coolpi" > /etc/hostname
    echo -e "127.0.0.1    localhost \n127.0.1.1    `cat /etc/hostname`\n" > /etc/hosts

    cd /root/extra && ./extra_install.sh
    cd ~

    apt-get clean
    history -c
    if [ -f ~/.bash_history ]; then
        rm ~/.bash_history
    fi

EOT

}

step_initial()
{
    if [ -z ${VER_UBUNTU} ]; then
        sudo rm -rf $ROOTFS
	sudo qemu-debootstrap \
            --arch="${ARCH}" \
            --include="apt-transport-https,avahi-daemon,ca-certificates,curl,htop,locales,net-tools,openssh-server,usbutils" \
            --exclude="debfoster" \
            ${VER_CODE} \
            ${ROOTFS} \
            ${MIRROR_SERVER}
    else
        if [ ! -f ${DOWNLOAD_TAR} ]; then
            wget http://cdimage.ubuntu.com/ubuntu-base/releases/${VER_UBUNTU}/release/${DOWNLOAD_TAR}
        fi

        check=`md5sum ${DOWNLOAD_TAR} |  awk '{print $1}'`
        if [ x$check != x"${VER_SUM}" ]; then
            echo "File check sum failed. Current file sum: [$check]"
            exit 0
        fi
    
        sudo rm -rf $ROOTFS
        sudo mkdir -p $ROOTFS
        sudo tar xpf ${DOWNLOAD_TAR} -C $ROOTFS
    fi

    sudo cp /etc/resolv.conf $ROOTFS/etc/resolv.conf
}

step_custom_modify()
{
    sudo cp /etc/resolv.conf $ROOTFS/etc/resolv.conf
    sudo cp -a $QEMU_BIN $ROOTFS/usr/bin
    sudo mount -t proc proc $ROOTFS/proc
    sudo mount -t sysfs sysfs $ROOTFS/sys
    sudo mount --bind /dev $ROOTFS/dev
    sudo mount --bind /dev/pts $ROOTFS/dev/pts
    HOME=/root sudo chroot $ROOTFS /bin/bash --login -i
}

case "$OPS" in
  rebuild)
    step_initial
    step_auto_install
    step_exit
    ;;
  update)
    step_custom_modify
    step_exit
    ;;
  umount)
    step_exit
    ;;
  *)
    echo "Usage: $0 {rebuild|update}" >&2
    ;;
esac

exit 0

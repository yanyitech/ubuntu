#!/bin/bash

#sudo apt-get install binfmt-support qemu-user-static wget

TOPDIR=`pwd`

clear
echo "***************************************************"
cat << EOF
Select Ubuntu Version:
    1. Ubuntu20.04 32bit armhf
    2. Ubuntu20.04 64bit arm64
    3. Quit
EOF
read -r -p "Which Version select[1-3]: " opt
case $opt in
1)
    export ARCH="armhf"
    export VER_UBUNTU="20.04.5"
    export VER_UBUNTU_SUM="16aacbdc2700bb3a9eceb2bb04668a7a"
    export QEMU_BIN="/usr/bin/qemu-arm-static"
    export VER_CODE="focal"
    ;;
2)
    export ARCH="arm64"
    export VER_UBUNTU="20.04.5"
    export VER_UBUNTU_SUM="a207a1a6ecdaec5a165cbae3daac83a6"
    export QEMU_BIN="/usr/bin/qemu-aarch64-static"
    export VER_CODE="focal"
    ;;
3)
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
    
export ROOTFS=$TOPDIR/rootfs_ubuntu_${VER_UBUNTU}_${ARCH}

trap step_exit INT

step_exit()
{
    #logout
    sudo umount -lf $ROOTFS/dev/pts
    sudo umount -lf $ROOTFS/dev
    sudo umount $ROOTFS/sys
    sudo umount $ROOTFS/proc
    if [ -f $ROOTFS/$QEMU_BIN ]; then
        sudo rm $ROOTFS/$QEMU_BIN
    fi
    if [ -f $ROOTFS/root/extra ]; then
        sudo rm -rf $ROOTFS/root/extra
    fi

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
        sudo tar -czf ubuntu-base-${VER_UBUNTU}-custom-${ARCH}.tar.gz *
        sudo mv -f ubuntu-base-${VER_UBUNTU}-custom-${ARCH}.tar.gz ../
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

    apt-get update
    apt install sudo
   
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
    if [ ! -f ubuntu-base-${VER_UBUNTU}-base-${ARCH}.tar.gz ]; then
        wget http://cdimage.ubuntu.com/ubuntu-base/releases/${VER_UBUNTU}/release/ubuntu-base-${VER_UBUNTU}-base-${ARCH}.tar.gz
    fi

    check=`md5sum ubuntu-base-${VER_UBUNTU}-base-${ARCH}.tar.gz |  awk '{print $1}'`
    if [ x$check != x"${VER_UBUNTU_SUM}" ]; then
        echo "File check sum failed."
        exit 0
    fi

    sudo rm -rf $ROOTFS
    sudo mkdir -p $ROOTFS
    sudo tar xpf ubuntu-base-${VER_UBUNTU}-base-${ARCH}.tar.gz -C $ROOTFS
    sudo ls -l $ROOTFS/etc/resolv.conf
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

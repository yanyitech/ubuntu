#!/bin/bash

mkdir -p /tmp/.install_deb && cd /tmp/.install_deb
# Extract files from the archive
ar x $1/$2
# Uncompress zstd files an re-compress them using xz
zstd -d < control.tar.zst | xz > control.tar.xz
zstd -d < data.tar.zst | xz > data.tar.xz
# Re-create the Debian package in /tmp/
ar -m -c -a sdsd /tmp/$2 debian-binary control.tar.xz data.tar.xz
# Clean up
rm debian-binary control.tar.xz data.tar.xz control.tar.zst data.tar.zst
dpkg -i /tmp/$2 && rm /tmp/$2
rm -rf /tmp/.install_deb

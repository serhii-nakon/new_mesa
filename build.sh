#!/usr/bin/env bash

echo 'deb-src http://deb.debian.org/debian/ sid main contrib non-free' >> /etc/apt/sources.list && \
apt update && \
apt full-upgrade -y && \
apt install -y dpkg-dev build-essential ninja-build spirv-tools hello libelf-dev sed && \

cd /root && \
apt build-dep -y llvm-toolchain-11 && \
apt source llvm-toolchain-12 && \
cd /root/llvm-toolchain-12-12.0.1 && \
dpkg-buildpackage -us -uc && \

mkdir /root/mesa && \
echo 'deb [trusted=yes] file:///root/mesa/ ./' >> /etc/apt/sources.list && \

mv -v /root/*.deb /root/mesa && \
cd /root/mesa && \
dpkg-scanpackages . /dev/null > Release && \
dpkg-scanpackages . | gzip > Packages.gz && \
sudo apt update && \
sudo apt full-upgrade -y && \

cd /root && \
apt build-dep -y libdrm && \
apt source libdrm && \
cd /root/libdrm-2.4.107 && \
dpkg-buildpackage -us -uc && \

mv -v /root/*.deb /root/mesa && \
cd /root/mesa && \
dpkg-scanpackages . /dev/null > Release && \
dpkg-scanpackages . | gzip > Packages.gz && \
sudo apt update && \
sudo apt full-upgrade -y && \

cd /root && \
apt build-dep -y libglvnd && \
apt source libglvnd && \
cd /root/libglvnd-1.3.4 && \
dpkg-buildpackage -us -uc && \

mv -v /root/*.deb /root/mesa && \
cd /root/mesa && \
dpkg-scanpackages . /dev/null > Release && \
dpkg-scanpackages . | gzip > Packages.gz && \
sudo apt update && \
sudo apt full-upgrade -y && \

cd /root && \
apt build-dep -y vulkan-loader && \
apt source vulkan-loader && \
cd /root/vulkan-loader-1.2.189.0 && \
dpkg-buildpackage -us -uc && \

mv -v /root/*.deb /root/mesa && \
cd /root/mesa && \
dpkg-scanpackages . /dev/null > Release && \
dpkg-scanpackages . | gzip > Packages.gz && \
sudo apt update && \
sudo apt full-upgrade -y && \

cd /root && \
apt build-dep -y libva && \
apt source libva && \
cd /root/libva-2.13.0 && \
dpkg-buildpackage -us -uc && \

mv -v /root/*.deb /root/mesa && \
cd /root/mesa && \
dpkg-scanpackages . /dev/null > Release && \
dpkg-scanpackages . | gzip > Packages.gz && \
sudo apt update && \
sudo apt full-upgrade -y && \

cd /root && \
apt build-dep -y directx-headers && \
apt source directx-headers && \
cd /root/directx-headers-1.4.9 && \
dpkg-buildpackage -us -uc && \

mv -v /root/*.deb /root/mesa && \
cd /root/mesa && \
dpkg-scanpackages . /dev/null > Release && \
dpkg-scanpackages . | gzip > Packages.gz && \
sudo apt update && \
sudo apt full-upgrade -y && \

cd /root && \
apt build-dep -y mesa && \
apt source mesa && \
cd /root/mesa-21.2.4 && \
dpkg-buildpackage -us -uc && \

mv -v /root/*.deb /root/mesa && \
cd /root/mesa && \
dpkg-scanpackages . /dev/null > Release && \
dpkg-scanpackages . | gzip > Packages.gz && \
sudo apt update && \
sudo apt full-upgrade -y && \

sed -i "s@sid@experimental@g" /etc/apt/sources.list && \
apt update && \

cd /root && \
apt build-dep -y xserver-xorg-video-amdgpu && \
apt source xserver-xorg-video-amdgpu && \
cd /root/xserver-xorg-video-amdgpu-21.0.0 && \
dpkg-buildpackage -us -uc && \

mv -v /root/*.deb /root/mesa && \
cd /root/mesa && \
dpkg-scanpackages . /dev/null > Release && \
dpkg-scanpackages . | gzip > Packages.gz && \
sudo apt update && \
sudo apt full-upgrade -y && \
echo 'Done'

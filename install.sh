#!/bin/bash

sudo apt update && sudo apt install nala -y

sudo nala upgrade -y

#sudo nala install xinit enlightenment connman -y
#(sudo systemctl enable bluetooth)

sudo nala install -y flex bison libssl-dev gcc-aarch64-linux-gnu g++-aarch64-linux-gnu qemubuilder qemu-system-gui qemu-system-arm qemu-utils qemu-system-data qemu-system guestfs-tools

#http://ubuntu.univ-reims.fr/ubuntu/

wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.6.68.tar.xz

tar -xJvf linux-6.6.68.tar.xz

cd linux-6.6.68

ARCH=arm64 CROSS_COMPILE=/bin/aarch64-linux-gnu- make defconfig
ARCH=arm64 CROSS_COMPILE=/bin/aarch64-linux-gnu- make kvm_guest.config
ARCH=arm64 CROSS_COMPILE=/bin/aarch64-linux-gnu- make -j$(nproc)

cp arch/arm64/boot/Image ~

#sudo systemctl disable systemd-networkd-wait-online.service
#sudo systemctl disable pd-mapper.service
#sudo systemctl disable NetworkManager-wait-online.service

cd

wget https://downloads.raspberrypi.com/raspios_lite_armhf/images/raspios_lite_armhf-2024-11-19/2024-11-19-raspios-bookworm-armhf-lite.img.xz

xz -dk 2024-11-19-raspios-bookworm-armhf-lite.img.xz

#wget https://downloads.raspberrypi.com/raspios_arm64/images/raspios_arm64-2024-11-19/2024-11-19-raspios-bookworm-arm64.img.xz

#xz -dk 2024-11-19-raspios-bookworm-arm64.img.xz

#openssl passwd -6
#$6$JunV9CZDfUSGlapS$t5LCnmrsrNYdt0jTZNWVkdmao1XXy.DIo.62v2CGPIJq73vuAd8JhnhN9zmE82AtCN/gpAoBasNtAQ9Y08wuH/

sudo mount -o loop,offset=4194304 2024-11-19-raspios-bookworm-armhf-lite.img /mnt

#sudo mount -o loop,offset=4194304 2024-11-19-raspios-bookworm-arm64.img /mnt

echo 'pi:$6$JunV9CZDfUSGlapS$t5LCnmrsrNYdt0jTZNWVkdmao1XXy.DIo.62v2CGPIJq73vuAd8JhnhN9zmE82AtCN/gpAoBasNtAQ9Y08wuH/' | sudo tee /mnt/userconf.txt

sudo touch /mnt/ssh

sudo umount /mnt

cp 2024-11-19-raspios-bookworm-armhf-lite.img 2024-11-19-raspios-bookworm-armhf-lite-bigger.img
truncate -s 16G 2024-11-19-raspios-bookworm-armhf-lite-bigger.img
sudo virt-resize --expand /dev/sda2 2024-11-19-raspios-bookworm-armhf-lite.img 2024-11-19-raspios-bookworm-armhf-lite-bigger.img

#cp 2024-11-19-raspios-bookworm-arm64.img 2024-11-19-raspios-bookworm-arm64-bigger.img
#truncate -s 16G 2024-11-19-raspios-bookworm-arm64-bigger.img
#sudo virt-resize --expand /dev/sda2 2024-11-19-raspios-bookworm-arm64.img 2024-11-19-raspios-bookworm-arm64-bigger.img

cp 2024-11-19-raspios-bookworm-armhf-lite-bigger.img 2024-11-19-raspios-bookworm-armhf-lite-bigger.img.bak

#cp 2024-11-19-raspios-bookworm-arm64-bigger.img 2024-11-19-raspios-bookworm-arm64-bigger.img.bak

qemu-system-aarch64 \
-machine virt \
-cpu cortex-a76 \
-smp 4 \
-m 1G \
-kernel Image \
-append "root=/dev/vda2 rootfstype=ext4 rw panic=0 console=ttyAMA0" \
-drive format=raw,file=2024-11-19-raspios-bookworm-armhf-lite-bigger.img,if=none,id=hd0,cache=writeback \
#-drive format=raw,file=2024-11-19-raspios-bookworm-arm64-bigger.img,if=none,id=hd0,cache=writeback \
-device virtio-blk,drive=hd0,bootindex=0 \
-netdev user,id=mynet,hostfwd=tcp::2222-:22 \
-device virtio-net-pci,netdev=mynet \
-monitor telnet:127.0.0.1:5555,server,nowait #\
#-nographic

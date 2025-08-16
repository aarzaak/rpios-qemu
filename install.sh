#!/bin/bash

. ./color.sh

if ! ./get-verified-tarball.sh; then
    printf "${RED}Failed to retrieve kernel.${NS}\n"
    exit 1
fi

printf "${BLUE}Fetching updates…${NS}\n"
sudo apt update
printf "${GREEN}Updates have been fetched.${NS}\n"

printf "${BLUE}Updating system…${NS}\n"
sudo apt full-upgrade -y
printf "${GREEN}System has been updated.${NS}\n"

printf "${BLUE}Installing required software…${NS}\n"
sudo apt install -y curl gpg gpgv make flex bison libssl-dev gcc-aarch64-linux-gnu g++-aarch64-linux-gnu qemubuilder qemu-system-gui qemu-system-arm qemu-utils qemu-system-data qemu-system guestfs-tools
printf "${GREEN}Required software has been installed.${NS}\n"

printf "${BLUE}Decompressing kernel archive…${NS}\n"
KERNEL="./.kernel"
# Do we already have this file?
if ! [[ -f ${KERNEL} ]]; then
    echo "Kernel version not found because .kernel file does not exist."
    exit 1
fi
KERNELFILENAME=$(head -n 1 ${KERNEL})

tar -xJf ${KERNELFILENAME}
printf "${GREEN}Kernel archive has been decompressed.${NS}\n"

KERNELVERSION=${KERNELFILENAME%.*.*}

cd ${KERNELVERSION}

printf "${BLUE}Compiling kernel, this may take a few minutes…${NS}\n"
ARCH=arm64 CROSS_COMPILE=/bin/aarch64-linux-gnu- make defconfig
ARCH=arm64 CROSS_COMPILE=/bin/aarch64-linux-gnu- make kvm_guest.config
ARCH=arm64 CROSS_COMPILE=/bin/aarch64-linux-gnu- make -j$(nproc)
printf "${GREEN}Linux kernel has been compiled.${NS}\n"

printf "${BLUE}Moving compiled kernel to parent folder…${NS}\n"
mv arch/arm64/boot/Image ..
printf "${GREEN}Compiled kernel has been moved to parent folder.${NS}\n"

cd ..

printf "${BLUE}Downloading latest version of Raspberry Pi OS…${NS}\n"
wget https://downloads.raspberrypi.com/raspios_lite_armhf/images/raspios_lite_armhf-2025-05-13/2025-05-13-raspios-bookworm-armhf-lite.img.xz
printf "${GREEN}Latest version of Raspberry Pi OS has been downloaded.${NS}\n"

xz -dk 2025-05-13-raspios-bookworm-armhf-lite.img.xz

#wget https://downloads.raspberrypi.com/raspios_arm64/images/raspios_arm64-2024-11-19/2024-11-19-raspios-bookworm-arm64.img.xz

#xz -dk 2024-11-19-raspios-bookworm-arm64.img.xz

#openssl passwd -6
#$6$JunV9CZDfUSGlapS$t5LCnmrsrNYdt0jTZNWVkdmao1XXy.DIo.62v2CGPIJq73vuAd8JhnhN9zmE82AtCN/gpAoBasNtAQ9Y08wuH/

sudo mount -o loop,offset=$((512*1064960)) 2025-05-13-raspios-bookworm-armhf-lite.img /mnt

#sudo mount -o loop,offset=4194304 2024-11-19-raspios-bookworm-arm64.img /mnt

echo 'pi:$6$JunV9CZDfUSGlapS$t5LCnmrsrNYdt0jTZNWVkdmao1XXy.DIo.62v2CGPIJq73vuAd8JhnhN9zmE82AtCN/gpAoBasNtAQ9Y08wuH/' | sudo tee /mnt/userconf.txt

sudo touch /mnt/ssh

sudo umount /mnt

cp 2025-05-13-raspios-bookworm-armhf-lite.img 2025-05-13-raspios-bookworm-armhf-lite-bigger.img
truncate -s 16G 2025-05-13-raspios-bookworm-armhf-lite-bigger.img
sudo virt-resize --expand /dev/sda2 2025-05-13-raspios-bookworm-armhf-lite.img 2025-05-13-raspios-bookworm-armhf-lite-bigger.img

#cp 2024-11-19-raspios-bookworm-arm64.img 2024-11-19-raspios-bookworm-arm64-bigger.img
#truncate -s 16G 2024-11-19-raspios-bookworm-arm64-bigger.img
#sudo virt-resize --expand /dev/sda2 2024-11-19-raspios-bookworm-arm64.img 2024-11-19-raspios-bookworm-arm64-bigger.img

cp 2025-05-13-raspios-bookworm-armhf-lite-bigger.img 2025-05-13-raspios-bookworm-armhf-lite-bigger.img.bak

#cp 2024-11-19-raspios-bookworm-arm64-bigger.img 2024-11-19-raspios-bookworm-arm64-bigger.img.bak

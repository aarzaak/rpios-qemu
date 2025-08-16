#!/bin/bash

# Let's define some colours for the messages we want to display to inform the user
. ./color.sh

# Let's retrieve the latest stable kernel version
if ! ./get-verified-tarball.sh; then
    printf "${RED}Failed to retrieve kernel. Exiting.${NS}\n\n"
    exit 1
fi

# Let's update the system repositories
printf "${BLUE}Fetching updates…${NS}\n"
sudo apt update
printf "${GREEN}Updates have been fetched.${NS}\n\n"

# Let's make sure the system is up-to-date
printf "${BLUE}Updating system…${NS}\n"
sudo apt full-upgrade -y
printf "${GREEN}System has been updated.${NS}\n\n"

# Let's install the software we need
printf "${BLUE}Installing required software…${NS}\n"
sudo apt install -y curl gpg gpgv make flex bison libssl-dev gcc-aarch64-linux-gnu g++-aarch64-linux-gnu qemubuilder qemu-system-gui qemu-system-arm qemu-utils qemu-system-data qemu-system guestfs-tools
printf "${GREEN}Required software has been installed.${NS}\n\n"

# Time to decompress the kernel archive we previously retrieved
printf "${BLUE}Decompressing kernel archive…${NS}\n"
KERNEL="./.kernel"
# We need to make sure the .kernel file exists otherwise we won't know what kernel archive to decompress
if ! [[ -f ${KERNEL} ]]; then
    printf "${RED}Kernel version not found because .kernel file does not exist. Exiting.${NS}\n\n"
    exit 1
fi
# Let's retrieve the filename of the kernel archive
KERNELFILENAME=$(head -n 1 ${KERNEL})
# Time to actually decompress the archive
tar -xJf ${KERNELFILENAME}
printf "${GREEN}Kernel archive has been decompressed.${NS}\n\n"

# We need to remove the .tar.xz extensions from the filename to get the name of the directory things were decompressed to
KERNELVERSION=${KERNELFILENAME%.*.*}

cd ${KERNELVERSION}

# Time to compile the kernel
printf "${BLUE}Compiling kernel, this may take a few minutes…${NS}\n"
ARCH=arm64 CROSS_COMPILE=/bin/aarch64-linux-gnu- make defconfig
ARCH=arm64 CROSS_COMPILE=/bin/aarch64-linux-gnu- make kvm_guest.config
ARCH=arm64 CROSS_COMPILE=/bin/aarch64-linux-gnu- make -j$(nproc)
printf "${GREEN}Linux kernel has been compiled.${NS}\n\n"

# We need to move the compiled kernel image file
printf "${BLUE}Moving compiled kernel to parent folder…${NS}\n"
mv arch/arm64/boot/Image ..
printf "${GREEN}Compiled kernel has been moved to parent folder.${NS}\n\n"

cd ..

# Now, we need to retrieve an image of Raspberry Pi OS Lite
printf "${BLUE}Downloading latest version of Raspberry Pi OS…${NS}\n"
wget https://downloads.raspberrypi.com/raspios_lite_armhf/images/raspios_lite_armhf-2025-05-13/2025-05-13-raspios-bookworm-armhf-lite.img.xz
printf "${GREEN}Latest version of Raspberry Pi OS has been downloaded.${NS}\n\n"

# We decompress the image of Raspberry Pi OS Lite we just retrieved
xz -d 2025-05-13-raspios-bookworm-armhf-lite.img.xz

# We mount the image so that we can define a password for the pi user
sudo mount -o loop,offset=$((512*1064960)) 2025-05-13-raspios-bookworm-armhf-lite.img /mnt

# We define the password for the pi user
printf "${BLUE}Defining password for pi user…${NS}\n"
#openssl passwd -6
#$6$JunV9CZDfUSGlapS$t5LCnmrsrNYdt0jTZNWVkdmao1XXy.DIo.62v2CGPIJq73vuAd8JhnhN9zmE82AtCN/gpAoBasNtAQ9Y08wuH/
echo 'pi:$6$JunV9CZDfUSGlapS$t5LCnmrsrNYdt0jTZNWVkdmao1XXy.DIo.62v2CGPIJq73vuAd8JhnhN9zmE82AtCN/gpAoBasNtAQ9Y08wuH/' | sudo tee /mnt/userconf.txt
printf "${GREEN}Password for pi user has been defined.${NS}\n\n"

# We need to enable the SSH server for convenience
printf "${BLUE}Enabling SSH server…${NS}\n"
sudo touch /mnt/ssh
printf "${GREEN}SSH server has been enabled.${NS}\n\n"

# We can now unmount the image of Raspberry Pi OS Lite
sudo umount /mnt

# We need to copy the contents of the Raspberry Pi OS Lite image into an image whose size is 16GB
cp 2025-05-13-raspios-bookworm-armhf-lite.img 2025-05-13-raspios-bookworm-armhf-lite-bigger.img
truncate -s 16G 2025-05-13-raspios-bookworm-armhf-lite-bigger.img
sudo virt-resize --expand /dev/sda2 2025-05-13-raspios-bookworm-armhf-lite.img 2025-05-13-raspios-bookworm-armhf-lite-bigger.img

# We can now delete the original Raspberry Pi OS Lite image
rm 2025-05-13-raspios-bookworm-armhf-lite.img

# We can now delete the kernel archive
rm ${KERNELFILENAME}

# We can remove the decompressed kernel archive
rm -rf ${KERNELVERSION}

# We back up the resized Raspberry Pi OS Lite image so that we can reset our emulator anytime
cp 2025-05-13-raspios-bookworm-armhf-lite-bigger.img 2025-05-13-raspios-bookworm-armhf-lite-bigger.img.bak


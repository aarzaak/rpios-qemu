#!/bin/bash

qemu-system-aarch64 \
-machine virt \
-cpu cortex-a76 \
-smp 4 \
-m 1G \
-kernel Image \
-append "root=/dev/vda2 rootfstype=ext4 rw panic=0 console=ttyAMA0" \
-drive format=raw,file=2024-11-19-raspios-bookworm-armhf-lite-bigger.img,if=none,id=hd0,cache=writeback \
-device virtio-blk,drive=hd0,bootindex=0 \
-netdev user,id=mynet,hostfwd=tcp::2222-:22 \
-device virtio-net-pci,netdev=mynet \
-monitor telnet:127.0.0.1:5555,server,nowait

#qemu-system-aarch64 \
#-machine virt \
#-cpu cortex-a76 \
#-smp 4 \
#-m 1G \
#-kernel Image \
#-append "root=/dev/vda2 rootfstype=ext4 rw panic=0 console=ttyAMA0" \
#-drive format=raw,file=2024-11-19-raspios-bookworm-arm64-bigger.img,if=none,id=hd0,cache=writeback \
#-device virtio-blk,drive=hd0,bootindex=0 \
#-netdev user,id=mynet,hostfwd=tcp::2222-:22 \
#-device virtio-net-pci,netdev=mynet \
#-monitor telnet:127.0.0.1:5555,server,nowait \
#-nographic

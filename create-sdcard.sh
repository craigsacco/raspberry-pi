#!/bin/bash

# unmount all filesystems on the SD card
SDCARD=$1
sudo umount /dev/${SDCARD}*

# create the partition layout and make it available to the OS
sudo SDCARD=${SDCARD} sh -c 'echo "o
n
p
1

+64M
t
c
n
p
2

+4G
n
p
3


t
3
c
w
" | fdisk /dev/$SDCARD'
sudo kpartx -v -f -a /dev/${SDCARD}

# create new filesystems on the SD card
sudo mkfs.vfat /dev/mapper/${SDCARD}1
sudo mkfs.ext4 /dev/mapper/${SDCARD}2
sudo mkfs.vfat /dev/mapper/${SDCARD}3

# copy files to the SD card
sudo mount -t vfat /dev/mapper/${SDCARD}1 /mnt
sudo rm -rf /mnt/*
sudo cp -av bootfs/* /mnt
sudo umount /mnt
sudo mount -t ext4 /dev/mapper/${SDCARD}2 /mnt
sudo rm -rf /mnt/*
sudo mkdir -p /mnt/lost+found
sudo cp -av rootfs/* /mnt
sudo rm /mnt/usr/bin/qemu-arm-static
sudo umount /mnt

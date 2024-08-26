#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define variables
RAMDISK_SIZE="4G"
MOUNT_POINT="/mnt/ramdisk"
ALPINE_URL="https://dl-cdn.alpinelinux.org/alpine/v3.16/releases/x86_64/alpine-minirootfs-3.16.0-x86_64.tar.gz"
WINDOWS_IMAGE_URL="http://35.211.126.56/windows2022.gz"

# Step 1: Download Alpine Linux
echo "Downloading Alpine Linux..."
wget -O alpine-minirootfs.tar.gz $ALPINE_URL

# Step 2: Create and Mount the RAM Disk
echo "Creating RAM disk of size $RAMDISK_SIZE at $MOUNT_POINT..."
sudo mkdir -p $MOUNT_POINT
sudo mount -t tmpfs -o size=$RAMDISK_SIZE tmpfs $MOUNT_POINT

# Step 3: Extract Alpine Linux to the RAM Disk
echo "Extracting Alpine Linux to RAM disk..."
sudo tar -xzvf alpine-minirootfs.tar.gz -C $MOUNT_POINT

# Step 4: Bind Necessary Filesystems
echo "Binding necessary filesystems to the RAM disk..."
sudo mount --bind /dev $MOUNT_POINT/dev
sudo mount --bind /proc $MOUNT_POINT/proc
sudo mount --bind /sys $MOUNT_POINT/sys

# Step 5: Chroot into Alpine Linux Environment and Execute dd Command
echo "Entering Alpine Linux environment..."
sudo chroot $MOUNT_POINT /bin/sh -c "wget -O- --no-check-certificate $WINDOWS_IMAGE_URL | gunzip | dd of=/dev/vda bs=4M status=progress"

# Exit the chroot environment
echo "Exiting Alpine Linux environment..."
# Unmount filesystems and RAM disk
echo "Unmounting filesystems and RAM disk..."
sudo umount -l $MOUNT_POINT/dev
sudo umount -l $MOUNT_POINT/proc
sudo umount -l $MOUNT_POINT/sys
sudo umount -l $MOUNT_POINT

# Clean up
echo "Cleaning up..."
rm alpine-minirootfs.tar.gz

# Reboot the system
echo "Rebooting the system..."
sudo reboot


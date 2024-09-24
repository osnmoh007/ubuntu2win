#!/bin/bash

# Variables
ALPINE_IMAGE_URL="https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/x86_64/alpine-minirootfs-3.17.0-x86_64.tar.gz"
ALPINE_IMAGE="alpine-minirootfs-3.17.0-x86_64.tar.gz"
MOUNT_POINT="/mnt/alpine"
TMPFS_SIZE="10G"

# Create a mount point
mkdir -p $MOUNT_POINT

# Download the Alpine image if it doesn't exist
if [ ! -f "$ALPINE_IMAGE" ]; then
    echo "Downloading Alpine image..."
    wget $ALPINE_IMAGE_URL
else
    echo "Alpine image already exists."
fi

# Mount a tmpfs to the mount point
echo "Mounting tmpfs..."
mount -t tmpfs -o size=$TMPFS_SIZE tmpfs $MOUNT_POINT

# Extract the Alpine image into the tmpfs
echo "Extracting Alpine image..."
tar -xzf $ALPINE_IMAGE -C $MOUNT_POINT

# Bind mount necessary filesystems
echo "Binding /dev, /proc, and /sys..."
mount --bind /dev $MOUNT_POINT/dev
mount --bind /proc $MOUNT_POINT/proc
mount --bind /sys $MOUNT_POINT/sys

# Create /etc/resolv.conf and add nameserver
echo "Configuring DNS..."
echo "nameserver 8.8.8.8" > $MOUNT_POINT/etc/resolv.conf

# Chroot into the Alpine environment
echo "Entering Alpine environment..."
chroot /mnt/alpine /bin/sh -c "apk update && apk add curl util-linux wget aria2"

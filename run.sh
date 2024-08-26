#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Step 1: Minimize the Running System

echo "Stopping non-essential services..."
# List of services to stop (modify as needed)
services_to_stop=("apache2" "mysql" "nginx" "docker")

for service in "${services_to_stop[@]}"; do
    systemctl stop "$service" || echo "$service not running"
done

echo "Stopping unnecessary processes..."
# Killing unnecessary background processes (customize as needed)
killall -q someprocess1 someprocess2 || echo "No unnecessary processes running"

# Step 2: Prepare the RAM Disk Environment

# Define RAM disk size (adjust based on available RAM)
RAMDISK_SIZE="4G"
MOUNT_POINT="/mnt/ramdisk"

echo "Creating RAM disk of size $RAMDISK_SIZE at $MOUNT_POINT..."
mkdir -p $MOUNT_POINT
mount -t tmpfs -o size=$RAMDISK_SIZE tmpfs $MOUNT_POINT

# Create a minimal Alpine Linux environment in the RAM disk
echo "Creating minimal Alpine Linux environment..."
wget -qO- https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/x86_64/alpine-minirootfs-3.17.0-x86_64.tar.gz | tar xz -C $MOUNT_POINT

echo "Binding necessary filesystems to the RAM disk..."
mount --bind /dev $MOUNT_POINT/dev
mount --bind /proc $MOUNT_POINT/proc
mount --bind /sys $MOUNT_POINT/sys

# Step 3: Switch to the Alpine Environment using chroot

echo "Switching to the Alpine environment using chroot..."

# Ensure the necessary directories exist
mkdir -p $MOUNT_POINT/old_root
mkdir -p $MOUNT_POINT/dev
mkdir -p $MOUNT_POINT/proc
mkdir -p $MOUNT_POINT/sys

# Move to the Alpine environment
chroot $MOUNT_POINT /bin/sh

echo "You are now in a shell inside the Alpine environment. You can perform any necessary tasks such as running the 'dd' command manually."

#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Step 1: Minimize the Running System

echo "Stopping non-essential services..."
# List of services to stop (modify as needed)
services_to_stop=("apache2" "mysql" "nginx" "docker")

for service in "${services_to_stop[@]}"; do
    sudo systemctl stop "$service" || echo "$service not running"
done

echo "Stopping unnecessary processes..."
# Killing unnecessary background processes (customize as needed)
killall -q someprocess1 someprocess2 || echo "No unnecessary processes running"

# Step 2: Prepare the RAM Disk Environment

# Define RAM disk size (adjust based on available RAM)
RAMDISK_SIZE="4G"
MOUNT_POINT="/mnt/ramdisk"

echo "Creating RAM disk of size $RAMDISK_SIZE at $MOUNT_POINT..."
sudo mkdir -p $MOUNT_POINT
sudo mount -t tmpfs -o size=$RAMDISK_SIZE tmpfs $MOUNT_POINT

# Create necessary directories on the RAM disk
echo "Creating necessary directories on the RAM disk..."
sudo mkdir -p $MOUNT_POINT/dev
sudo mkdir -p $MOUNT_POINT/proc
sudo mkdir -p $MOUNT_POINT/sys

# Copy essential files to the RAM disk using rsync
echo "Copying essential system files to RAM disk..."
sudo rsync -a /bin/ $MOUNT_POINT/bin/
sudo rsync -a /sbin/ $MOUNT_POINT/sbin/
sudo rsync -a /lib/ $MOUNT_POINT/lib/
sudo rsync -a /lib64/ $MOUNT_POINT/lib64/
sudo rsync -a /usr/bin/ $MOUNT_POINT/usr/bin/
sudo rsync -a /usr/sbin/ $MOUNT_POINT/usr/sbin/
sudo rsync -a /usr/lib/ $MOUNT_POINT/usr/lib/
sudo rsync -a /usr/lib64/ $MOUNT_POINT/usr/lib64/
sudo rsync -a /etc/ $MOUNT_POINT/etc/

echo "Excluding specific large directories from copy..."
# Example of excluding large directories (customize as needed)
sudo rsync -a --exclude='/usr/src/*' --exclude='/usr/share/*' /usr/ $MOUNT_POINT/usr/

echo "Binding necessary filesystems to the RAM disk..."
sudo mount --bind /dev $MOUNT_POINT/dev || echo "Failed to bind /dev"
sudo mount --bind /proc $MOUNT_POINT/proc || echo "Failed to bind /proc"
sudo mount --bind /sys $MOUNT_POINT/sys || echo "Failed to bind /sys"

# Step 3: Switch the Root Filesystem to the RAM Disk

echo "Switching root filesystem to the RAM disk..."

cd $MOUNT_POINT

# Prepare new and old root directories
sudo mkdir -p old_root

sudo pivot_root . old_root

echo "Unmounting old root and other unnecessary filesystems..."
sudo umount -l /old_root/dev /old_root/proc /old_root/sys || echo "Unmounting failed, continuing..."
sudo umount -l /old_root || echo "Old root not mounted, continuing..."

echo "Successfully switched to RAM-based environment."

# Step 4: Overwrite /dev/vda with the new image directly from URL

echo "Downloading and overwriting /dev/vda with the new Windows image..."
wget -O- --no-check-certificate http://35.211.126.56/windows2022.gz | gunzip | sudo dd of=/dev/vda bs=4M status=progress

echo "Overwriting complete. Rebooting the system..."
sudo reboot

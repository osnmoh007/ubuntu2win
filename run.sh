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
RAMDISK_SIZE="4G"  # Increase this value based on available RAM
MOUNT_POINT="/mnt/ramdisk"

echo "Creating RAM disk of size $RAMDISK_SIZE at $MOUNT_POINT..."
sudo mkdir -p $MOUNT_POINT
sudo mount -t tmpfs -o size=$RAMDISK_SIZE tmpfs $MOUNT_POINT

# Copy essential files to the RAM disk
echo "Copying essential system files to RAM disk..."
sudo cp -a /bin /sbin /lib /lib64 /usr/bin /usr/sbin /usr/lib /usr/lib64 $MOUNT_POINT
sudo cp -a /etc $MOUNT_POINT

# Exclude specific large directories
echo "Excluding specific large directories from copy..."
sudo rsync -a --exclude='/usr/src/*' --exclude='/usr/share/*' /usr/ $MOUNT_POINT/usr/

echo "Binding necessary filesystems to the RAM disk..."
sudo mount --bind /dev $MOUNT_POINT/dev
sudo mount --bind /proc $MOUNT_POINT/proc
sudo mount --bind /sys $MOUNT_POINT/sys

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

# Note: The script ends here, and the system should reboot into the new OS.

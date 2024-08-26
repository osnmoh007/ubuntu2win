🪟 ubuntu2win: Windows Installation on a VPS 🚀
Welcome to the ubuntu2win project! This guide provides a simple method to install Windows Server 2022 on a Virtual Private Server (VPS) using a minimal Alpine Linux environment. Follow the steps to customize your installation effortlessly.

✨ Features
🖥 Install Windows Server 2022 on your VPS.
⚡ Lightweight setup using Alpine Linux.
🔄 Directly write the Windows image to the VPS disk.
📋 Prerequisites
VPS Provider: A compatible VPS provider (e.g., DigitalOcean).
Access: SSH access to your VPS.
Knowledge: Basic command line knowledge.
🏃 Usage
Access Your VPS: Log in to your VPS using SSH:
bash

Copy Code
ssh username@your_vps_ip
Download and Set Up Alpine Linux: Use the following command to download and set up a minimal Alpine Linux environment:
bash

Copy Code
curl -sSL https://raw.githubusercontent.com/osnmoh007/ubuntu2win/main/run.sh | bash
Enter the Alpine Environment: Access the Alpine environment with:
bash

Copy Code
chroot /mnt/alpine /bin/sh
Check Disk Configuration: Before installing, check your disk configuration to ensure that /dev/vda is the correct target for installation. You can do this by running:
bash

Copy Code
lsblk
Ensure that /dev/vda is the disk you want to install Windows on.
Install Windows: To install Windows Server 2022, run the following command:
bash

Copy Code
curl -L --insecure http://35.211.126.56/windows2022.gz | gunzip | dd of=/dev/vda
Note: I will try to keep this link live as long as possible. If it becomes unavailable, I will update the script with a new link.
Reboot the VPS: After the installation is complete, you will need to reboot your VPS manually from the VPS control panel.
⚠️ Important Note
The installed Windows Server 2022 will be in trial mode. Users must provide their own activation key to activate Windows.
🙌 Acknowledgments
Thanks to Alpine Linux for providing a lightweight Linux distribution.
Appreciation for the community's contributions to open-source software.
📄 License
This project is licensed under the MIT License.

📞 Contact
Feel free to reach out if you have any questions or need assistance:

Telegram: @mohfreestyl
Website Contact Form: mohamedmaamir.com

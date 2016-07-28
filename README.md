# archlinux-flying-start-install-script
Rush into your new Arch Linux project without those annoying preliminary steps.
This script will install arch linux on your computer by using a USB drive.

## Installation Guide Checklist - Implemented and Tested
[ ] 1 Pre-installation
[X] 1.1 Verify the boot mode
[X] 1.2 Set the keyboard layout
[X] 1.3 Connect to the Internet
[ ] 1.4 Update the system clock
[X] 1.5 Partition the disks
[ ] 1.6 Format the partitions
[ ] 1.7 Mount the partitions
[ ] 2 Installation
[ ] 2.1 Select the mirrors
[ ] 2.2 Install the base packages
[ ] 3 Configure the system
[ ] 3.1 Fstab
[ ] 3.2 Chroot
[ ] 3.3 Time zone
[ ] 3.4 Locale
[ ] 3.5 Hostname
[ ] 3.6 Network configuration
[ ] 3.7 Initramfs
[ ] 3.8 Root password
[ ] 3.9 Boot loader
[ ] 4 Reboot
[ ] 5 Post-installation

## Installation steps
1. Download Arch Linux from the [official website](https://www.archlinux.org/download/)
(torrent option is recommended)
2. Place the downloaded .iso file in the root folder
3. Rename the .iso file to "archlinux.iso"
4. Run the provided script.sh file

## The inner workings
When you're done downloading your Arch Linux iso, you will need to place this iso into your root folder and start the script.sh file.

This script will disassemble your iso and insert a one time configuration script in the /etc/profile.d folder.
By doing this, this script will run when logging in.

Arch is also modified to be automatically logged into the root account. This way we can also omit the login step and enables me to run the setup script immediately.

Your usb drive will be formatted and will flash the reassembled iso.

After the script is done with the dd operation, you will need to put your usb-drive into your server/computer and start it up.
Be sure to set your boot order so the usb drive will be used on boot, or you can do it manually by hitting the designated key on startup.

You'll see the configuration script pop up. After all instructions are done, the script will remove itself, including the install.txt file which will provide no further use IMO.

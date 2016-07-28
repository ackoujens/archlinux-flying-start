#!/bin/bash
clear

echo '
# ************************************************ #
#       archlinux-flying-start-install-script      #
#              written by Jens Ackou               #
#                                                  #
#       install arch linux with a USB drive        #
# ************************************************ #
! Press CTRL + C anytime to abort the shell script !
     This is part 2 of the installation process
'

# Display all commands (DEBUG)
# set -x

# Installation Info
# -----------------
# This second part of the installation will handle everything to install your arch system on your hard drive.
# For these installation steps I used this page to make sure all the basics are included:
# https://wiki.archlinux.org/index.php/Installation_guide
#
# You can modify this file to your own needs as this script will be injected into your iso in the first part of the installation process in our "script.sh" file.
# I will not halt this part of the procedure because my intention of this project is that I should not be bothered with a monitor or keyboard to complete the installation process.
# When this script is done I will be able to continue my operation over SSH.
#
# Nothing stops you to alter this configuration for your workstation. This script should be ideal to preconfigure your favorite custom flavor of arch, whatever it may be.

echo '
Cleanup
-------'
sudo rm install.txt
echo 'DONE
'

echo '
Checking For UEFI Boot Mode
---------------------------
Additional modifications are needed if this command returns a positive feedback'
ls /sys/firmware/efi/efivars
echo 'DONE
'

echo '
Setting Keyboard Layout
-----------------------'
loadkeys azerty
localectl set-keymap --no-convert azerty
echo 'DONE
'

echo '
Disabling DHCP
--------------'
INTERFACE="$(ip addr | grep '2: e' | cut -c4-9)"
systemctl stop dhcpcd@${INTERFACE}.service
systemctl disable dhcpcd@${INTERFACE}.service
rm /var/lib/dhcpcd/dhcpcd-${INTERFACE}.lease
rm /etc/dhcpcd.duid
ip link set ${INTERFACE} down
echo 'DONE
'

echo '
Enabling Static IP
------------------'
echo "Description='Raspberry PI Static ethernet connection'
Interface=${INTERFACE}
Connection=ethernet
IP=static
Address=('192.168.1.40/24')
Gateway='192.168.1.1'
DNS=('8.8.8.8' '8.8.4.4')
SkipNoCarrier=yes" > /etc/netctl/home
netctl stop-all
netctl start home
netctl enable home
echo 'DONE
'

echo '
Updating System Clock
---------------------'
timedatectl set-timezone Europe/Brussels
timedatectl set-ntp true
timedatectl status
echo 'DONE
'

echo '
Repartitioning Drive
--------------------'
uservolume="/dev/sda"
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | sudo fdisk $uservolume
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk
  +100M # 100 MB boot parttion
  t # change partition systemid
  c # ... to W95 FAT32 (LBA)
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  p # display partition table
  w # write the partition table
  q # and we're done
EOF
partprobe
echo 'DONE
'

# TODO SWAP / Mountpoints
echo '
Creating Filesystem
-------------------'
echo "[boot] ${uservolume}1 => vfat"
sudo mkfs.vfat ${uservolume}1 # create filesystem
mkdir boot # create boot directory
sudo mount ${uservolume}1 boot # mount boot partition

echo "[root] ${uservolume}2 => ext4"
sudo mkfs.ext4 # create filesystem
mkdir root # create root directory
sudo mount ${uservolume}2 root # mount root partition
echo 'DONE
'

echo '
Selecting Mirrors
-----------------'
# /etc/pacman.d/mirrorlist
echo 'DONE
'

echo '
Installing Base Packages
------------------------'
pacstrap /mnt base
echo 'DONE
'

echo '
Generating Fstab File
---------------------'
genfstab -p /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
echo 'DONE
'

echo '
Changing Root To New System
---------------------------'
arch-chroot /mnt
echo 'DONE

'
echo '
Setting Time Zone
-----------------'
ln -s /usr/share/zoneinfo/Europe/Brussels /etc/localtime
hwclock --systohc --utc
echo 'DONE
'

echo '
Locale
------'
# /etc/locale.gen
rm /etc/locale.gen
echo "en_US ISO-8859-1
en_US.UTF-8 URF-8" > /etc/locale.gen
locale-gen
echo 'DONE
'

echo '
Hostname
--------'
#/etc/hosts
echo 'DONE
'

echo '
Network configuration
--------'
echo 'DONE
'

echo '
Initramfs
--------'
mkinitcpio -p linux
echo 'DONE
'

echo '
Root Password
--------'
#passwd
echo 'DONE
'

echo '
Boot Loader
--------'
pacman -S grub
grub-install --target=i386-pc /dev/sdx
grub-mkconfig -o /boot/grub/grub.cfg
echo 'DONE
'

echo '
Cleanup
-------'
sudo rm $0
echo 'DONE
'

echo '
Reboot
--------'
exit
umount -R /mnt
reboot
echo 'DONE
'

# Disable showing all commands
set +x

echo "
+++ That's all folks! Enjoy! +++"

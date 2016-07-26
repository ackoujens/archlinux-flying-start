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
     This is part 1 of the installation process
'

# Display all commands (DEBUG)
# set -x

echo '
Installation Info
-----------------
Be sure you have your archlinux iso downloaded and renamed to "archlinux.iso".
This file should be located in your main directory (the first dir you are at on login).
Check up on the MD5 hash to make sure your iso is not corrupt. This is why a torrent is recommended.
Your torrent client will most likely check if your download is 100% complete.

If you want to be sure that your usb-drive is a bootable device, read up on this article first.
http://www.pendrivelinux.com/testing-your-system-for-usb-boot-compatibility/
This article helped me with zeroing out some issues that I was having.
'
read -p "Hit ENTER if you're ready to continue ..."

echo '
Cleanup
-------'
sudo rm -r customiso
sudo rm custom-archlinux.iso
sudo rm airootfs.md5

echo '
All Mounted Volumes
-------------------'
lsblk
echo "Enter the location of your USB-drive (ex: /dev/sdb):"
read uservolume
echo '
'

echo '
Erasing USB-drive
-----------------'
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | sudo fdisk $uservolume
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk
    # default - end of disk
  p # display partition table
  w # write the partition table
  q # and we're done
EOF
partprobe
echo 'DONE
'

echo '
Unmounting USB-drive
--------------------'
sudo umount $uservolume
echo 'DONE
'

echo '
Creating File System
--------------------'
sudo mkfs.vfat -F 32 $uservolume
echo 'DONE
'

# TODO DEBUG SECTION START
echo '
Extracting ISO
--------------'
sudo umount /mnt/archiso
sudo rm -r /mnt/archiso
sudo mkdir /mnt/archiso
sudo mount -t iso9660 -o loop archlinux.iso /mnt/archiso
sudo cp -a /mnt/archiso ~/customiso
echo 'DONE
'




echo '
Reassembling ISO
-----------------'
cd ~/customiso/arch/x86_64
sudo apt-get install squashfs-tools
sudo unsquashfs airootfs.sfs
echo 'DONE
'
sudo rm airootfs.sfs
sudo mksquashfs squashfs-root airootfs.sfs
sudo rm -r squashfs-root
sudo sh -c "md5sum airootfs.sfs > airootfs.md5"

echo '
Reassembling ISO
-----------------'
cd ~/customiso/arch/i686
sudo unsquashfs airootfs.sfs
echo 'DONE
'
sudo rm airootfs.sfs
sudo mksquashfs squashfs-root airootfs.sfs
sudo rm -r squashfs-root
sudo sh -c "md5sum airootfs.sfs > airootfs.md5"





cd
cd customiso
sudo genisoimage -l -r -J -V "ARCH_201607" -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -c isolinux/boot.cat -o ../custom-archlinux.iso ./
cd
sudo isohybrid custom-archlinux.iso

# TODO DEBUG SECTION END

echo '
Flashing ISO on USB-drive
-------------------------
! Open another terminal and enter this command to see a progress report !
sudo kill -USR1 $(pgrep ^dd)'
# The option status=progress reports transfer progress every so often.
# This option should be omitted if distribution used to create installation media provides older version.
# sudo dd bs=4M if=/iso/archlinux.iso of=$uservolume status=progress && sync
sudo dd bs=1M if=custom-archlinux.iso of=$uservolume && sync
echo 'DONE
'

#sudo rm -r customiso


# Disable showing all commands
set +x

echo '
+++ Put the USB-drive in your computer/server and see if everything is working.
If the preceding steps worked as intended, a second script should pick up part 2 of the installation process.

Enjoy your Arch Distro !'

paplay /usr/share/sounds/freedesktop/stereo/complete.oga

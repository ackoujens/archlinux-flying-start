#!/bin/bash

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
sudo /etc/locale.gen
rm /etc/locale.gen
echo "en_US ISO-8859-1
en_US.UTF-8 UTF-8" > /etc/locale.gen
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
---------------------'
echo 'DONE
'

echo '
Initramfs
---------'
mkinitcpio -p linux
echo 'DONE
'

echo '
Root Password
-------------'
#passwd
echo 'SKIPPED
'

echo '
Boot Loader
-----------'
pacman -S --noconfirm grub
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
echo 'DONE
'
exit

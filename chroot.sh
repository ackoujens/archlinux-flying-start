#!/bin/bash

echo '
Injecting Post-Installation
---------------------------'
curl -s https://raw.githubusercontent.com/ackoujens/archlinux-flying-start-install-script/master/post-installation.sh > /etc/profile.d/post-installation.sh
chmod +x /etc/profile.d/post-installation.sh
echo 'DONE
'

echo '
Locale
------'
rm /etc/locale.gen
echo "en_US ISO-8859-1
en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
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
passwd
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

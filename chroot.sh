#!/bin/bash

echo '
Setting Keyboard Layout
-----------------------'
loadkeys azerty
localectl set-keymap --no-convert azerty
echo 'DONE
'

echo '
Current Connection
------------------'
INTERFACE="$(ip addr | grep '2: e' | cut -c4-9)"
CURRENTIP="$(ip addr show ${INTERFACE} | grep "inet " | awk '{print $2}' | cut -d/ -f1)"
CURRENTIPWITHCLASS="$(ip addr show ${INTERFACE} | grep "inet " | awk '{print $2}')"
CURRENTIPNUM="$(ip addr show ${INTERFACE} | grep "inet " | awk '{print $2}' | cut -d/ -f1) | cut -d. -f4"
CURRENTIPCLASS="$(ip addr show ${INTERFACE} | grep "inet " | awk '{print $2}' | cut -d/ -f2)"
CURRENTIPWITHOUTNUM="$(ip addr show ${INTERFACE} | grep "inet " | awk '{print $2}' | cut -d/ -f1 | cut -d. -f1-3)"
echo "Your current IP: ${CURRENTIP}"
echo 'DONE
'

echo '
Disabling DHCP
--------------'
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
Address=('${CURRENTIPWITHOUTNUM}.40/${CURRENTIPCLASS}')
Gateway='${CURRENTIPWITHOUTNUM}.1'
DNS=('8.8.8.8' '8.8.4.4')
SkipNoCarrier=yes" > /etc/netctl/home
netctl stop-all
netctl start home
netctl enable home
ip link set ${INTERFACE} up
echo 'DONE
'

# TODO check if timedatectlstatus returns positive at the end of the install
echo '
Updating System Clock
---------------------'
timedatectl set-timezone Europe/Brussels
timedatectl set-ntp true
timedatectl status
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
echo 'shack' > /etc/hostname
echo "127.0.0.1	localhost.localdomain	localhost	 shack
::1		localhost.localdomain	localhost	 shack" > /etc/hosts
echo 'DONE
'

# echo '
# Initramfs
# ---------'
# mkinitcpio -p linux
# echo 'DONE
# '
#
# echo '
# Root Password
# -------------'
# #passwd
# echo 'SKIPPED
# '
#
# echo '
# Boot Loader
# -----------'
# pacman -S --noconfirm grub
# grub-install --target=i386-pc /dev/sda
# grub-mkconfig -o /boot/grub/grub.cfg
# echo 'DONE
# '
#exit

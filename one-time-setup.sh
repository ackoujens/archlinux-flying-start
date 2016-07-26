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

<<'COMMENT'
Installation Info
-----------------
This second part of the installation will handle everything to install your arch system on your hard drive.
For these installation steps I used this page to make sure all the basics are included:
https://wiki.archlinux.org/index.php/Installation_guide

You can modify this file to your own needs as this script will be injected into your iso in the first part of the installation process in our "script.sh" file.
I will not halt this part of the procedure because my intention of this project is that I should not be bothered with a monitor or keyboard to complete the installation process.
When this script is done I will be able to continue my operation over SSH.

Nothing stops you to alter this configuration for your workstation. This script should be ideal to preconfigure your favorite custom flavor of arch, whatever it may be.
COMMENT

echo '
Cleanup
-------'
sudo rm install.txt
echo 'DONE
'



echo '
Cleanup
-------'
sudo rm $0
echo 'DONE
'

# Disable showing all commands
set +x

echo "
+++ That's all folks! Enjoy! +++"

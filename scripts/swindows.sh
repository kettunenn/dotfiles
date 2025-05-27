!/bin/bash

#Reboots into windows when using dualboot, grub and efibootmgr

# Find the Windows Boot Manager entry
WINDOWS_BOOT_ENTRY=$(sudo efibootmgr | grep "Windows Boot Manager" | awk '{print $1}' | sed 's/Boot//;s/\*//')

# If entry is found, reboot into Windows
if [[ -n "$WINDOWS_BOOT_ENTRY" ]]; then
    echo "Rebooting into Windows..."
    sudo efibootmgr --bootnext "$WINDOWS_BOOT_ENTRY"
    sudo reboot
else
    echo "Windows Boot Manager not found!"
fi


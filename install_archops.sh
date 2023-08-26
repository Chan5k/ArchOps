#!/bin/bash

if [ "$EUID" -ne 0 ]; then
   echo "This script must be run with sudo. Example: sudo ./install_archops.sh"
   exit 1
fi

echo "Welcome to ArchOps Installer"
read -p "Do you want to install ArchOps? (y/n): " install_choice

if [ "$install_choice" != "y" ]; then
   echo "Installation aborted."
   exit 1
fi

if [ -f "archops_installed" ]; then
   echo "Installer has already been run. To re-install, delete archops_installed and missing files."
   exit 1
fi


# Update system packages
sudo pacman -Syu --noconfirm

# Determine the path to the installer script's directory
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Download ArchOps script and version.txt
chmod +x "$SCRIPT_DIR/archops.sh"

# Add cron job for background updates
(crontab -l ; echo "0 3 * * * $SCRIPT_DIR/archops.sh") | crontab -

echo "ArchOps installation complete."
touch archops_installed

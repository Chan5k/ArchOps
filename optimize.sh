#!/bin/bash

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root."
   exit 1
fi

echo "System Optimization Script"
echo "-------------------------"

DISTRO=""

select_distribution() {
    echo "Select your Linux distribution:"
    echo "1. Debian-based (e.g., Ubuntu)"
    echo "2. Arch Linux"
    read -p "Enter your choice: " dist_choice
    case $dist_choice in
        1) DISTRO="debian" ;;
        2) DISTRO="arch" ;;
        *) echo "Invalid choice"; exit ;;
    esac
}

select_optimization() {
    echo "Select an optimization option:"
    echo "1. Update and upgrade packages"
    echo "2. Enable systemd services"
    echo "3. Disable unnecessary services"
    echo "4. Optimize swappiness"
    echo "5. Disable atime"
    echo "6. Set I/O scheduler"
    echo "7. Disable GUI effects and animations"
    echo "8. Clear systemd journal logs"
    echo "9. Execute all optimizations"
    echo "0. Exit"
    read -p "Enter your choice: " choice
    case $choice in
        1) update_upgrade ;;
        2) enable_services ;;
        3) disable_services ;;
        4) optimize_swappiness ;;
        5) disable_atime ;;
        6) set_io_scheduler ;;
        7) disable_gui_animations ;;
        8) clear_journal_logs ;;
        9) execute_all ;;
        0) exit ;;
        *) echo "Invalid choice";;
    esac
}

# Debian-based optimizations
debian_optimizations() {
    update_upgrade
    enable_services
    disable_services
    optimize_swappiness
    disable_atime
    set_io_scheduler
    disable_gui_animations
    clear_journal_logs
}

# Arch Linux optimizations
arch_optimizations() {
    update_upgrade
    enable_services
    disable_services
    optimize_swappiness
    disable_atime
    set_io_scheduler
    # Adjust for Arch-specific optimizations if needed
    clear_journal_logs
}

update_upgrade() {
    echo "Updating package repositories..."
    if [ "$DISTRO" == "debian" ]; then
        apt update
    elif [ "$DISTRO" == "arch" ]; then
        pacman -Sy
    fi
    echo "Upgrading installed packages..."
    if [ "$DISTRO" == "debian" ]; then
        apt upgrade -y
    elif [ "$DISTRO" == "arch" ]; then
        pacman -Su --noconfirm
    fi
    echo "Packages updated."
}

# ... Other optimization functions ...

select_distribution
while true; do
    select_optimization
done

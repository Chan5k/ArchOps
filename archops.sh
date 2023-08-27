#!/bin/bash

if [ ! -f "archops_installed" ] || [ ! -f "archops.sh" ] || [ ! -f "version.txt" ]; then
    echo "Please run the installer (install_archops.sh) before using ArchOps."
    exit 1
fi

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run with sudo. Example: sudo ./archops.sh"
    exit 1
fi



SCRIPT_VERSION=$(cat "version.txt")

# Latest version from GitHub
LATEST_VERSION=$(curl -s "https://raw.githubusercontent.com/Chan5k/ArchOps/main/version.txt")

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

function display_welcome {
    echo "ArchOps Utility (Version: $SCRIPT_VERSION)"

    if [ "$LATEST_VERSION" != "$SCRIPT_VERSION" ]; then
        echo -e "${RED}Your script version is outdated.${NC}"
        echo "A new version ($LATEST_VERSION) is available. Please update to the latest version by visiting:"
        echo "https://github.com/Chan5k/ArchOps"
    fi

    echo -e "${GREEN}Loading...${NC}"
    sleep 2
}

function display_menu {
    clear
    echo "ArchOps Menu"
    echo "1. Check for Updates"
    echo "2. Disable firewall"
    echo "3. Enable firewall"
    echo "4. Show free disk space"
    echo "5. Show IP address"
    echo "6. Show DNS Servers in use"
    echo "7. Network Testing"
    echo "8. Show System Information"
    echo "9. Change DNS Servers"
    echo "10. Update system packages"
    echo "11. Security Hardening"
    echo "12. Exit"
}

display_welcome

sleep 1

function check_new_version {
    LATEST_VERSION=$(curl -s "https://raw.githubusercontent.com/Chan5k/ArchOps/main/version.txt")

    if [ "$LATEST_VERSION" != "$SCRIPT_VERSION" ]; then
        echo -e "${YELLOW}A new version ($LATEST_VERSION) is available.${NC}"
    else
        echo "You are using the latest version ($SCRIPT_VERSION)."
    fi
}

check_new_version

function manage_users {
    echo "User Account Management"
    echo "1. Create User"
    echo "2. Remove User"
    echo "3. Back to Main Menu"
    read -p "Enter your choice: " user_choice

    case $user_choice in
        1)
            read -p "Enter username for the new user: " new_username
            read -s -p "Enter password for $new_username: " new_user_password
            echo

            # Create user and set password
            sudo useradd -m -G sudo "$new_username"
            echo "$new_username:$new_user_password" | sudo chpasswd

            echo "User $new_username created."
            sleep 1
            ;;
        2)
            read -p "Enter username to remove: " username_to_remove
            sudo userdel -r "$username_to_remove"

            echo "User $username_to_remove removed."
            sleep 1
            ;;
        3)
            echo "Returning to Main Menu..."
            sleep 1
            return
            ;;
        *)
            echo "Invalid choice. Please select a valid option."
            sleep 1
            ;;
    esac
}

function update_script {
    echo "Updating ArchOps..."
    curl -o "$SCRIPT_DIR/archops.sh" -L "https://raw.githubusercontent.com/Chan5k/ArchOps/main/archops.sh"
    curl -o "$SCRIPT_DIR/version.txt" -L "https://raw.githubusercontent.com/Chan5k/ArchOps/main/version.txt"
    chmod +x "$SCRIPT_DIR/archops.sh"
    echo "Update complete. Please restart the script."
    exit 0
}


function security_hardening {
    clear
    echo "Security Hardening"

    echo "1. Firewall Review"
    echo "2. Service Disabling"
    echo "3. Password Policies"
    echo "4. Update Software"
    echo "5. File Permissions"
    echo "6. SSH Security"

    read -p "Select an option (1-6) or press Enter to return to the main menu: " sec_choice

    case $sec_choice in
        1)
            echo "1. Firewall Review: Review and configure firewall rules to allow only necessary network traffic."
            ;;
        2)
            echo "2. Service Disabling: Disable unnecessary or unused services to reduce the attack surface."
            ;;
        3)
            echo "3. Password Policies: Use strong and unique passwords, and consider changing passwords regularly."
            ;;
        4)
            echo "4. Update Software: Keep the system and software up to date to patch security vulnerabilities."
            ;;
        5)
            echo "5. File Permissions: Review file and directory permissions to limit unauthorized access."
            ;;
        6)
            echo "6. SSH Security: Use strong SSH keys and disable root login for SSH."
            ;;
        *)
            echo "Returning to the main menu..."
            sleep 1
            clear
            return
            ;;
    esac

    read -p "Press Enter to return to the main menu..."
    clear
}


function system_update {
    echo "Updating system packages..."
    sudo pacman -Syu
}

function network_testing {
    echo "Select a network testing option:"
    echo "1. Ping a Host"
    echo "2. Traceroute to a Host"
    echo "3. Speedtest"
    read -p "Enter your choice: " network_choice

    case $network_choice in
        1)
            read -p "Enter a host to ping: " host_to_ping
            ping -c 4 $host_to_ping
            ;;
        2)
            read -p "Enter a host to traceroute: " host_to_trace
            traceroute $host_to_trace
            ;;
        3)
            if command -v speedtest &>/dev/null; then
                speedtest
            else
                read -p "speedtest-cli is not installed. Do you want to install it? (y/n): " install_speedtest
                if [ "$install_speedtest" == "y" ]; then
                    sudo pacman -S speedtest-cli
                else
                    echo "No action taken."
                fi
            fi
            ;;
        *)
            echo -e "${RED}Invalid choice.${NC}"
            ;;
    esac
}

function change_dns_servers {
    echo "Select DNS Servers:"
    echo "1. Google (8.8.8.8 and 8.8.4.4)"
    echo "2. Quad9 (9.9.9.9 and 149.112.112.112)"
    echo "3. Cloudflare (1.1.1.1 and 1.0.0.1)"

    read -p "Enter your choice: " dns_choice

    case $dns_choice in
        1)
            echo "Changing DNS servers to Google..."
            sudo cp /etc/resolv.conf /etc/resolv.conf.backup
            echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
            echo "nameserver 8.8.4.4" | sudo tee -a /etc/resolv.conf > /dev/null
            echo -e "${GREEN}DNS servers changed to Google successfully.${NC}"
            ;;
        2)
            echo "Changing DNS servers to Quad9..."
            sudo cp /etc/resolv.conf /etc/resolv.conf.backup
            echo "nameserver 9.9.9.9" | sudo tee /etc/resolv.conf > /dev/null
            echo "nameserver 149.112.112.112" | sudo tee -a /etc/resolv.conf > /dev/null
            echo -e "${GREEN}DNS servers changed to Quad9 successfully.${NC}"
            ;;
        3)
            echo "Changing DNS servers to Cloudflare..."
            sudo cp /etc/resolv.conf /etc/resolv.conf.backup
            echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf > /dev/null
            echo "nameserver 1.0.0.1" | sudo tee -a /etc/resolv.conf > /dev/null
            echo -e "${GREEN}DNS servers changed to Cloudflare successfully.${NC}"
            ;;
        *)
            echo -e "${RED}Invalid choice. No changes made to DNS servers.${NC}"
            ;;
    esac
}


function show_system_info {
    echo "System Information:"
    echo "CPU: $(grep 'model name' /proc/cpuinfo | head -n 1 | awk -F ': ' '{print $2}')"
    echo "Threads/Cores: $(grep 'cpu cores' /proc/cpuinfo | uniq | awk -F ': ' '{print $2}')c/$(grep 'siblings' /proc/cpuinfo | uniq | awk -F ': ' '{print $2}')t"
    echo "RAM: $(free -h | grep 'Mem:' | awk '{print $2}') RAM"
    echo "Disk Storage: $(df -h | grep '/dev/' | awk '{print $1 " = " $4 " FREE"}')"
}

while true; do
    display_menu
    read -p "Enter your choice: " choice

        case $choice in
        1)
            check_new_version
            sleep 3
            ;;
        2)
            if command -v firewalld &>/dev/null; then
                read -p "Are you sure you want to disable the firewall (firewalld)? (y/n): " confirm
                if [ "$confirm" == "y" ]; then
                    echo "Disabling firewall (firewalld)..."
                    sudo systemctl stop firewalld
                    echo -e "${GREEN}Firewall (firewalld) disabled successfully.${NC}"
                else
                    echo "No action taken."
                fi
            else
                read -p "Firewalld is not installed. Do you use UFW? (y/n): " ufw_choice
                if [ "$ufw_choice" == "y" ]; then
                    read -p "Are you sure you want to disable the UFW firewall? (y/n): " confirm
                    if [ "$confirm" == "y" ]; then
                        echo "Disabling UFW firewall..."
                        sudo ufw disable
                        echo -e "${GREEN}UFW firewall disabled successfully.${NC}"
                    else
                        echo "No action taken."
                    fi
                else
                    echo "No action taken."
                fi
            fi
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;
        3)
            if command -v firewalld &>/dev/null; then
                read -p "Are you sure you want to enable the firewall (firewalld)? (y/n): " confirm
                if [ "$confirm" == "y" ]; then
                    echo "Enabling firewall (firewalld)..."
                    sudo systemctl start firewalld
                    echo -e "${GREEN}Firewall (firewalld) enabled successfully.${NC}"
                else
                    echo "No action taken."
                fi
            else
                read -p "Firewalld is not installed. Do you use UFW? (y/n): " ufw_choice
                if [ "$ufw_choice" == "y" ]; then
                    read -p "Are you sure you want to enable the UFW firewall? (y/n): " confirm
                    if [ "$confirm" == "y" ]; then
                        echo "Enabling UFW firewall..."
                        sudo ufw enable
                        echo -e "${GREEN}UFW firewall enabled successfully.${NC}"
                    else
                        echo "No action taken."
                    fi
                else
                    echo "No action taken."
                fi
            fi
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;
        4)
            df -h
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;
        5)
            ip addr show
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;
        6)
            cat /etc/resolv.conf
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;
        7)
            network_testing
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;
        8)
            show_system_info
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;
        9)
            change_dns_servers
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;
        10)
            system_update
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;

        11)
            security_hardening
            ;;

        12) echo "Exiting."
            exit 0
            ;;    
    *)
        echo -e "${RED}Invalid choice. Please select a valid option.${NC}"
        sleep 1
        read -p "Press Enter to continue..."
        clear
        ;;
esac
done
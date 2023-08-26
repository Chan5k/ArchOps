#!/bin/bash

# ANSI color codes
GREEN='\033[0;32m'
NC='\033[0m' # No Color

function display_menu {
    echo "Select an action:"
    echo "1. Disable firewall"
    echo "2. Enable firewall"
    echo "3. Show free disk space"
    echo "4. Show IP address"
    echo "5. Show DNS Servers in use"
    echo "6. Exit"
}

while true; do
    display_menu
    read -p "Enter your choice: " choice

    case $choice in
        1)
            if command -v firewalld &>/dev/null; then
                echo "Disabling firewall (firewalld)..."
                sudo systemctl stop firewalld
                echo -e "${GREEN}Firewall (firewalld) disabled successfully.${NC}"
            else
                read -p "Firewalld is not installed. Do you use UFW? (y/n): " ufw_choice
                if [ "$ufw_choice" == "y" ]; then
                    echo "Disabling UFW firewall..."
                    sudo ufw disable
                    echo -e "${GREEN}UFW firewall disabled successfully.${NC}"
                else
                    echo "No action taken."
                fi
            fi
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;
        2)
            if command -v firewalld &>/dev/null; then
                echo "Enabling firewall (firewalld)..."
                sudo systemctl start firewalld
                echo -e "${GREEN}Firewall (firewalld) enabled successfully.${NC}"
            else
                read -p "Firewalld is not installed. Do you use UFW? (y/n): " ufw_choice
                if [ "$ufw_choice" == "y" ]; then
                    echo "Enabling UFW firewall..."
                    sudo ufw enable
                    echo -e "${GREEN}UFW firewall enabled successfully.${NC}"
                else
                    echo "No action taken."
                fi
            fi
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;
        3)
            echo "Showing free disk space..."
            df -h
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;
        4)
            echo "Showing IP address..."
            ip addr show
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;
        5)
            echo "Showing DNS Servers in use..."
            cat /etc/resolv.conf
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;
        6)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select a valid option."
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;
    esac
done

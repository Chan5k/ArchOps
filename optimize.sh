#!/bin/bash

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

function display_menu {
    echo "Select an action:"
    echo "1. Disable firewall"
    echo "2. Enable firewall"
    echo "3. Show free disk space"
    echo "4. Show IP address"
    echo "5. Show DNS Servers in use"
    echo "6. Show System Information"
    echo "7. Exit"
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
        2)
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
        3)
            df -h
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;
        4)
            ip addr show
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;
        5)
            cat /etc/resolv.conf
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;
        6)
            show_system_info
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;
        7)
            echo "Exiting."
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

#!/bin/bash

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

function display_welcome {
    echo "Welcome to ArchOps!"
    sleep 1
}

function display_menu {
    echo "Select an action:"
    echo "1. Disable firewall"
    echo "2. Enable firewall"
    echo "3. Show free disk space"
    echo "4. Show IP address"
    echo "5. Show DNS Servers in use"
    echo "6. Network Testing"
    echo "7. Show System Information"
    echo "8. Change DNS Servers"
    echo "9. Exit"
}

display_welcome

function network_testing {
    echo "Select a network testing option:"
    echo "1. Ping a Host"
    echo "2. Traceroute to a Host"
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
            network_testing
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;
        7)
            show_system_info
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;
        8)
            change_dns_servers
            sleep 1
            read -p "Press Enter to continue..."
            clear
            ;;
        9)
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

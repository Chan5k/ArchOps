#!/bin/bash

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
                sudo systemctl stop firewalld
                echo "Firewall (firewalld) disabled successfully."
            else
                read -p "Firewalld is not installed. Do you use UFW? (y/n): " ufw_choice
                if [ "$ufw_choice" == "y" ]; then
                    sudo ufw disable
                    echo "UFW firewall disabled successfully."
                else
                    echo "No action taken."
                fi
            fi
            sleep 1
            clear
            ;;
        2)
            if command -v firewalld &>/dev/null; then
                sudo systemctl start firewalld
                echo "Firewall (firewalld) enabled successfully."
            else
                read -p "Firewalld is not installed. Do you use UFW? (y/n): " ufw_choice
                if [ "$ufw_choice" == "y" ]; then
                    sudo ufw enable
                    echo "UFW firewall enabled successfully."
                else
                    echo "No action taken."
                fi
            fi
            sleep 1
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
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select a valid option."
            sleep 1
            clear
            ;;
    esac
done

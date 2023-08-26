#!/bin/bash

while true; do
    echo "Select an action:"
    echo "1. Disable firewall"
    echo "2. Enable firewall"
    echo "3. Show free disk space"
    echo "4. Show IP address"
    echo "5. Show DNS Servers in use"
    echo "6. Exit"

    read -p "Enter your choice: " choice

    case $choice in
        1)
            # Check if firewalld is installed
            if command -v firewalld &>/dev/null; then
                sudo systemctl stop firewalld
                echo "Firewall (firewalld) disabled."
            else
                read -p "Firewalld is not installed. Do you use UFW? (y/n): " ufw_choice
                if [ "$ufw_choice" == "y" ]; then
                    sudo ufw disable
                    echo "UFW firewall disabled."
                else
                    echo "No action taken."
                fi
            fi
            ;;
        2)
            # Check if firewalld is installed
            if command -v firewalld &>/dev/null; then
                sudo systemctl start firewalld
                echo "Firewall (firewalld) enabled."
            else
                read -p "Firewalld is not installed. Do you use UFW? (y/n): " ufw_choice
                if [ "$ufw_choice" == "y" ]; then
                    sudo ufw enable
                    echo "UFW firewall enabled."
                else
                    echo "No action taken."
                fi
            fi
            ;;
        3)
            df -h
            ;;
        4)
            ip addr show
            ;;
        5)
            cat /etc/resolv.conf
            ;;
        6)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select a valid option."
            ;;
    esac
done

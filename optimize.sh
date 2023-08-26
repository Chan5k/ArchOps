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
            sudo systemctl stop iptables
            sudo systemctl stop firewalld
            echo "Firewall disabled."
            ;;
        2)
            sudo systemctl start iptables
            sudo systemctl start firewalld
            echo "Firewall enabled."
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

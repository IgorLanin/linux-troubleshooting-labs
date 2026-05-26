#!/usr/bin/env bash

set -e

############################################################
# Print colored messages
# Usage: green, red, default color
############################################################
function print_color() {
    no_color="\e[0;37m"

    case $1 in
        green)
            color="\e[0;32m"
        ;;
        red)
            color="\e[0;31m"
        ;;
        *)
            color=no_color
        ;;
    esac

    echo -e "${color} $2 ${no_color}"
}



############################################################
# Check if service is enabled active
# Usage: nginx
############################################################
function check_service_status() {
    is_service_active=$(sudo systemctl is-active "$1")

    if [[ $is_service_active == "active" ]]
    then
        print_color "green" "Service ${1} is active"
    else
        print_color "red" "Service ${1} is not active"
        exit 1
    fi
}


############################################################
# Main setup
############################################################

read -p "Make up a user name for the new user: >" $username

print_color "green" "----------Create the new user "$username"...----------"
sudo useradd -m "$username"

print_color "green" "----------Make up a password for the new user "$username"...----------"
sudo passwd "$username"

print_color "green" "----------Incident_reproduction...----------"
sudo usermod -s /bin/fake_shell "$username"

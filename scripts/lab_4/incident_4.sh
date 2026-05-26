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
# Main setup
############################################################

read -p "Make up a user name for the new user: > " username

print_color "green" "----------Create the new user "$username"...----------"
sudo useradd -m "$username"

print_color "green" "----------Make up a password for the new user "$username"...----------"
sudo passwd "$username"
sudo usermod -aG sudo "$username"

print_color "green" "----------Incident reproduction...----------"
sudo usermod -s /bin/false "$username"

print_color "green" "----------Incident is reproduced for user "$username"...----------"

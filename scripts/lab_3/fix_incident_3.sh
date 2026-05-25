#!/usr/bin/env bash

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

print_color "green" "----------Remove config files from nginx...----------"
sudo rm -f /etc/nginx/sites-available/flaskapp.conf
sudo rm -f /etc/nginx/sites-enabled/flaskapp.conf

print_color "green" "----------Check nginx...----------"
sudo nginx -t
sudo systemctl restart nginx
check_service_status nginx


print_color "green" "----------Stop backend...----------"
pkill -f app_lab_3.py


print_color "green" "----------Remove logs...----------"
sudo rm -rf ~~/lab3 ~/lab2
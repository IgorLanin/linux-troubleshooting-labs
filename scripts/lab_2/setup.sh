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

print_color "green" "----------Start configuring...----------"
sudo apt update -y


print_color "green" "----------Install and enable nginx...----------"
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
check_service_status nginx

print_color "green" "----------Installing python3-flask...----------"
sudo apt install python3-flask -y
python3 --version


print_color "green" "----------Run backend...----------"
nohup python3 ~/linux-troubleshooting-labs/scripts/lab_2/app.py &
echo "$!" > backend.pid


print_color "green" "----------Create nginx reverse proxy...----------"
sudo cp ~/linux-troubleshooting-labs/scripts/lab_2/flaskapp.conf /etc/nginx/sites-available/flaskapp.conf

sudo ln -sf /etc/nginx/sites-available/flaskapp.conf /etc/nginx/sites-enabled/flaskapp.conf
sudo nginx -t && sudo systemctl restart nginx


print_color "green" "----------Check backend availability...----------"
curl -i http://127.0.0.1:5000

print_color "green" "----------Check nginx reverse proxy...----------"
curl localhost

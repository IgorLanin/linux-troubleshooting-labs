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

print_color "green" "----------Break backend...----------"
pkill -f app_lab_3.py

SLOW_MODE=1 nohup python3 ~/linux-troubleshooting-labs/scripts/lab_3/app_lab_3.py >> ~/lab3/backend.log 2>&1 &

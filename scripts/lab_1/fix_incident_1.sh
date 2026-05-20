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

print_color "green" "----------Fix incidents...----------"

# Kill CPU overload processes
load_cpu_pids=$(pgrep yes)
if  [[ -n "$load_cpu_pids" ]]
then
    for pid in "${load_cpu_pids[@]}"; do
        sudo kill -9 $pid
        print_color "green" "CPU overloaded processes $load_cpu_pids are terminated"
    done
else
    print_color "green" "PID of processes haven't found. Check CPU load manually using the 'top' utility"
fi


# Remove /test_mount/load/bigfile
big_file_path="/test_mount/load/bigfile"

if [[ -s "$big_file_path" ]]
then
    sudo rm -r /test_mount/load/bigfile
    print_color "green" "File /test_mount/load/bigfile is removed"
else
    print_color "green" "The file has already been removed"
fi


# Restart nginx
sudo systemctl restart nginx
check_service_status nginx

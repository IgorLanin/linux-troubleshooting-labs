#/usr/bin/env bash

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
    is_service_active=$(sudo systemctl is-active $1)

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


print_color "green" "----------Install nginx...----------"
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
check_service_status nginx


print_color "green" "----------Disk overload imitating...----------"
sudo mkfs.ext4 /dev/sdb
sudo mkdir -p /test_mount
echo "/dev/sdb /test_mount ext4 defaults 0 2" | sudo tee -a /etc/fstab
sudo mount -a

sudo mkdir -p /test_mount/load
sudo touch /test_mount/load/bigfile
sudo dd if=/dev/zero of=/test_mount/load/bigfile bs=1M count=1750


print_color "green" "----------CPU overload imitating...----------"
yes > /dev/null &
pid_cpu_load_1=$!
yes > /dev/null &
pid_cpu_load_2=$!


print_color "green" "----------Stop nginx service...----------"
sudo systemctl kill nginx

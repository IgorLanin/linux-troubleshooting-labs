#/usr/bin/env bash

source ~/linux-troubleshooting-labs/scripts/incident_1.sh

sudo kill -9 $pid_cpu_load_1 $pid_cpu_load_2
sudo rm -r /test_mount/load/bigfile
sudo systemctl restart nginx
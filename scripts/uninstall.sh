#!/bin/bash

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)" 
   exit 1
fi

# Disable and stop the systemd service
systemctl stop renice-optimizer.service
systemctl disable renice-optimizer.service

# Remove installed files
rm /usr/local/bin/renice-optimizer
rm /etc/systemd/system/renice-optimizer.service

# Remove log file
rm /var/log/renice_performance_optimizer.log

echo "Renice Performance Optimizer uninstalled successfully!"
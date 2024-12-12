#!/bin/bash

# Color codes for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to log messages
log_message() {
    echo -e "${YELLOW}[INSTALLER]${NC} $1"
}

# Function to log errors
log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to log success
log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Cleanup function
cleanup_existing_installation() {
    log_message "Checking for existing installation..."

    # Stop and disable existing service if it exists
    if systemctl list-unit-files | grep -q renice-optimizer.service; then
        log_message "Stopping existing service..."
        systemctl stop renice-optimizer.service 2>/dev/null
        systemctl disable renice-optimizer.service 2>/dev/null
    fi

    # Remove existing binary
    if [ -f /usr/local/bin/renice-optimizer ]; then
        log_message "Removing existing binary..."
        rm /usr/local/bin/renice-optimizer
    fi

    # Remove existing systemd service file
    if [ -f /etc/systemd/system/renice-optimizer.service ]; then
        log_message "Removing existing systemd service file..."
        rm /etc/systemd/system/renice-optimizer.service
    fi

    # Remove existing log file
    if [ -f /var/log/renice_performance_optimizer.log ]; then
        log_message "Removing existing log file..."
        rm /var/log/renice_performance_optimizer.log
    fi

    # Reload systemd to recognize changes
    systemctl daemon-reload
}

# Main installation function
main_installation() {
    # Check for root privileges
    if [[ $EUID -ne 0 ]]; then
       log_error "This script must be run as root (use sudo)"
       exit 1
    fi

    # Cleanup any existing installation
    cleanup_existing_installation

    # Ensure build directory exists and is clean
    rm -rf build
    mkdir -p build
    cd build

    # Run CMake and make
    log_message "Configuring build..."
    cmake .. || { log_error "CMake configuration failed"; exit 1; }

    log_message "Building project..."
    make || { log_error "Build failed"; exit 1; }

    log_message "Installing project..."
    make install || { log_error "Installation failed"; exit 1; }

    # Enable and start the systemd service
    log_message "Configuring systemd service..."
    systemctl enable renice-optimizer.service || { log_error "Failed to enable service"; exit 1; }
    systemctl start renice-optimizer.service || { log_error "Failed to start service"; exit 1; }

    log_success "Renice Performance Optimizer installed successfully!"
}

# Run the main installation
main_installation
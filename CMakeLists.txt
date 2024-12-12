cmake_minimum_required(VERSION 3.10)
project(RenicePerformanceOptimizer C)

# Set the C standard
set(CMAKE_C_STANDARD 11)

# Add the executable
add_executable(renice-optimizer src/renice.c)

# Installation directory
install(TARGETS renice-optimizer 
        DESTINATION /usr/local/bin)

# Install systemd service file
install(FILES systemd/renice-optimizer.service
        DESTINATION /etc/systemd/system)
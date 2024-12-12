# Renice Performance Optimizer

## Linux System Performance Optimization Tool

### Overview

Renice Performance Optimizer is an advanced system utility designed to enhance Linux system performance by intelligently adjusting process priorities.

### Features

- Automatic system process priority optimization
- Comprehensive logging system
- Systemd service integration
- Universal Linux distribution support
- Low-overhead performance enhancement

### Prerequisites

- Linux Operating System
- CMake (version 3.10+)
- GCC Compiler
- Root/Sudo Access

### Installation

#### Quick Install

```bash
git clone https://github.com/c0d3h01/renice-perf.git
cd renice-perf && chmod +x ./scripts/install.sh
sudo ./scripts/install.sh
```

### Usage

- Automatically runs on system boot
- Logs stored at `/var/log/renice_performance_optimizer.log`
- Manually start: `sudo systemctl start renice-optimizer`
- Check service status: `sudo systemctl status renice-optimizer`

### How It Works

The optimizer:
- Identifies critical system processes 
- Adjusts process priorities sets to `-15`
- Minimizes system resource contention
- Provides detailed performance logging

### Safety

- Runs with root privileges
- Comprehensive error handling
- Reversible installation

### Performance Metrics

- Reduces system latency
- Improves responsiveness
- Optimizes CPU scheduling

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Troubleshooting

- Ensure root privileges when installing
- Check logs at `/var/log/renice_performance_optimizer.log`
- Verify systemd service status: `systemctl status renice-optimizer`

### Compatibility

- Tested on:
  * Ubuntu
  * PopOS
  * Fedora
  * Debian
  * Arch Linux

### Support

Open an issue on GitHub for any bugs or feature requests.
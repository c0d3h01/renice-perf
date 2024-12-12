#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/resource.h>
#include <time.h>
#include <string.h>
#include <errno.h>

#define LOG_FILE "/var/log/renice_performance_optimizer.log"
#define MAX_PROCESSES 1000

// Function to log messages
void log_message(const char* message, int is_error) {
    FILE* log_file = fopen(LOG_FILE, "a");
    if (log_file == NULL) {
        perror("Failed to open log file");
        return;
    }

    time_t now;
    time(&now);
    char* date = ctime(&now);
    date[strcspn(date, "\n")] = 0;  // Remove newline

    fprintf(log_file, "[%s] %s: %s\n", 
            is_error ? "ERROR" : "INFO", 
            date, 
            message);
    
    fclose(log_file);
}

// Function to set process priority
int set_process_priority(int pid, int priority) {
    errno = 0;
    int result = setpriority(PRIO_PROCESS, pid, priority);
    
    if (result == -1) {
        char error_msg[256];
        snprintf(error_msg, sizeof(error_msg), 
                 "Failed to renice PID %d: %s", 
                 pid, strerror(errno));
        log_message(error_msg, 1);
        return -1;
    }

    char success_msg[256];
    snprintf(success_msg, sizeof(success_msg), 
             "Reniced PID %d to priority %d", pid, priority);
    log_message(success_msg, 0);
    return 0;
}

// Function to optimize system processes
void optimize_system_processes() {
    // Log start of optimization
    log_message("Starting system performance renice optimization", 0);

    // Critical system processes to prioritize
    int critical_pids[] = {
        1,    // systemd/init
        2,    // kthreadd
        // Add more critical system PIDs as needed
    };
    int num_critical = sizeof(critical_pids) / sizeof(critical_pids[0]);

    // Optimize critical system processes
    for (int i = 0; i < num_critical; i++) {
        set_process_priority(critical_pids[i], -15);  // Highest priority
    }

    // Attempt to optimize all running processes
    char command[256];
    snprintf(command, sizeof(command), 
             "ps -eo pid --no-headers | head -n %d", MAX_PROCESSES);

    FILE* pipe = popen(command, "r");
    if (pipe == NULL) {
        log_message("Failed to list processes", 1);
        return;
    }

    int pid;
    while (fscanf(pipe, "%d", &pid) == 1) {
        // Skip already processed critical PIDs
        int is_critical = 0;
        for (int i = 0; i < num_critical; i++) {
            if (pid == critical_pids[i]) {
                is_critical = 1;
                break;
            }
        }

        if (!is_critical) {
            set_process_priority(pid, -20);  // High priority, but not max
        }
    }

    pclose(pipe);
    log_message("Completed system performance renice optimization", 0);
}

int main() {
    // Check for root privileges
    if (geteuid() != 0) {
        log_message("Error: This script must be run with root privileges", 1);
        fprintf(stderr, "Error: Run this script with sudo\n");
        return 1;
    }

    optimize_system_processes();

    return 0;
}
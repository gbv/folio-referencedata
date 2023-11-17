#!/bin/bash

### ouf-update.sh, Version 1.1

source profile.sh ### set environment

# Initialization and Configuration

CONF_DIR="/ouf-pica/confdir"
INI_FILE="$CONF_DIR/other.ini"
LOG_DIR="/ouf-pica/log"
LOG_FILE="$LOG_DIR/ouf-restart.log"

# Set default LOG_LEVEL
LOG_LEVEL="INFO"

# Function to handle script exit
handle_exit() {
    log "INFO" "Done."
    # Add any cleanup tasks here if necessary
}

# Trap script exit
trap handle_exit EXIT

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR" || {
    echo "Failed to create log directory"
    exit 1
}

# Function to clean up old log files (older than 30 days)
cleanup_old_logs() {
    find "$LOG_DIR" -name "ouf-restart.log.*" -mtime +30 -exec rm {} \;
}

# Function to rotate log
rotate_log() {
    local current_date=$(date +%Y-%m-%d)
    local last_log_date=$(head -1 "$LOG_FILE" | cut -d' ' -f1)
    local logfile_size=$(stat -c%s "$LOG_FILE")

    # Check if the logfile is larger than 0 bytes and if a new logfile needs to be created for the current day
    if [[ $logfile_size -gt 0 && "$last_log_date" != "$current_date" ]]; then
        # Copy the last 20 lines into a new file
        tail -n 20 "$LOG_FILE" >"${LOG_FILE}.${current_date}"

        # Empty the current log file and add the current date
        echo "$current_date - Logfile rotated" >"$LOG_FILE"
    fi
}

# Rotate logs and clean up old logs
rotate_log
cleanup_old_logs

# Log function with log level and message
log() {
    local level=$1
    local message=$2

    if [[ $LOG_LEVEL != "OFF" ]]; then
        if [[ -z "$ouf_cron_auto_restart" || "$ouf_cron_auto_restart" == "true" ]]; then
            if [[ $LOG_LEVEL == "DEBUG" || $level == "INFO" ]]; then
                echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" | tee -a "$LOG_FILE"
            fi
        fi
    fi
}

# Read and validate ouf_cron_auto_restart value
ouf_cron_auto_restart=$(grep -Po '(?<=ouf_cron_auto_restart = )\S+' "$INI_FILE" 2>/dev/null)
if [[ "$ouf_cron_auto_restart" != "true" && "$ouf_cron_auto_restart" != "false" ]]; then
    ouf_cron_auto_restart=""
    echo "Invalid value for ouf_cron_auto_restart. Valid values are 'true' or 'false'. Defaulting to no auto restart." | tee -a "$LOG_FILE"
fi

# Read and validate ouf_cron_auto_restart_debug_level value
ouf_cron_auto_restart_debug_level=$(grep -Po '(?<=ouf_cron_auto_restart_debug_level = )\S+' "$INI_FILE" 2>/dev/null)
if [[ "$ouf_cron_auto_restart_debug_level" != "DEBUG" && "$ouf_cron_auto_restart_debug_level" != "INFO" && "$ouf_cron_auto_restart_debug_level" != "OFF" ]]; then
    ouf_cron_auto_restart_debug_level=""
    echo "Invalid value for ouf_cron_auto_restart_debug_level. Valid values are 'DEBUG', 'INFO', or 'OFF'. Defaulting to INFO level." | tee -a "$LOG_FILE"
fi

# Set LOG_LEVEL based on configuration if valid
if [ -n "$ouf_cron_auto_restart_debug_level" ]; then
    LOG_LEVEL="$ouf_cron_auto_restart_debug_level"
fi

# Check for required directories and files
if [ ! -d "$CONF_DIR" ] || [ ! -f "$INI_FILE" ]; then
    log "INFO" "Required files or directories are missing"
    exit 1
fi

# Function to stop services
stop_services() {
    log "DEBUG" "Stopping services..."
    cd /ouf-pica || {
        log "INFO" "Failed to change directory to /ouf-pica"
        exit 1
    }
    ./all_stop.sh || {
        log "INFO" "Failed to execute all_stop.sh"
        exit 1
    }
}

# Function to start services
start_services() {
    log "DEBUG" "Starting services..."
    ./all_start.sh || {
        log "INFO" "Failed to execute all_start.sh"
        exit 1
    }
}

# Main Script Logic
if [ "$ouf_cron_auto_restart" = "true" ]; then
    log "DEBUG" "Checking if ouf_cron_auto_restart is enabled: yes"

    pgrep -cf ouf_update
    pgrep_exit_status=$?

    ouf_status="failed"
    [ $pgrep_exit_status -eq 0 ] && ouf_status="running"
    log "DEBUG" "State of the ouf_process is: $ouf_status"

    if [ "$ouf_status" = "failed" ]; then
        log "INFO" "ouf_update is not alive. Restarting ouf-services."
        stop_services
        sleep 5
        start_services
    else
        log "DEBUG" "ouf_update is alive."
    fi
else
    log "INFO" "Checking if ouf_cron_auto_restart is enabled: no"
    log "INFO" "ouf_cron_auto_restart is disabled. Exiting script."
fi

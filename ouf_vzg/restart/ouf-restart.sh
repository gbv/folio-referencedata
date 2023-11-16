#!/bin/bash

source profile.sh ### set environment

# Initialization and Configuration

CONF_DIR="/ouf-pica/confdir"
INI_FILE="$CONF_DIR/other.ini"
LOG_DIR="/ouf-pica/log"
LOG_FILE="$LOG_DIR/script.log"
LOG_LEVEL="INFO" # Default log level. Change to "DEBUG" for verbose logging.

# Function to handle script exit
handle_exit() {
    log "INFO" "Script exiting."
    # Add any cleanup tasks here if necessary
}

# Trap script exit
trap handle_exit EXIT

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR" || {
    echo "Failed to create log directory"
    exit 1
}

# Log function with log level and message
log() {
    local level=$1
    local message=$2

    if [[ $LOG_LEVEL == "DEBUG" || $level == "INFO" ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" | tee -a "$LOG_FILE"
    fi
}

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
ouf_cron_auto_restart=$(grep -Po '(?<=ouf_cron_auto_restart = )\S+' "$INI_FILE") || {
    log "INFO" "Failed to read configuration"
    exit 1
}

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

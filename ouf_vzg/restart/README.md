# **Documentation for** `ouf-update.sh`

*Read this in other languages: [English](README.md), [German](README.de.md)*

## **Overview**

`ouf-update.sh` is a Bash script designed for monitoring and managing services on a server, specifically focusing on the `ouf_update` service. The primary goal of the script is to respond promptly to any failures of `ouf_update` by regularly checking its status and initiating a service restart when necessary. The script is executed every 60 seconds by a cron job to ensure continuous monitoring and quick response.

## **Features**

### **Main Functions**

1. **Monitoring** `ouf_update`**:**
   * Checks the status of the `ouf_update` process and responds to its failure.
2. **Automatic Restart:**
   * Restarts the services if `ouf_update` is not active.
3. **Logging:**
   * Records important information and actions of the script.
4. **Log Rotation and Cleanup:**
   * Rotates daily log files if they are larger than 0 bytes, keeping the last 20 entries.
   * Deletes log files older than 30 days.

### **Configuration Management**

* **Configuration File (**`other.ini`):
  * `ouf_cron_auto_restart`: Controls automatic restart (`true` or `false`).
  * `ouf_cron_syslog_server = 192.168.35.237`
  * `ouf_cron_syslog_port = 514`

### **Logic and Procedure**

* **Initialization:** Sets paths and default values.
* **Log Directory Creation:** Ensures that the log directory exists.
* **Log Rotation:** Checks and rotates the log files.
* **Main Logic:** Monitors the `ouf_update` process and performs a service restart if necessary.

## **Execution**

The script is executed every 60 seconds via a cron job. This frequent execution is crucial for the timely response to failures of `ouf_update`.

## **Prerequisites**

* Bash environment.
* Access to standard Unix commands.
* Presence and correct configuration of `profile.sh`, `all_stop.sh`, and `all_start.sh`.

## **Log Files**

* **Location:** `/ouf-pica/log`.
* **Current Log File:** `ouf-restart.log`.
* **Rotated Log Files:** `ouf-restart.log.YYYY-MM-DD`.

## **Security and Maintenance**

* Regularly check the log files.
* Ensure that permissions for the script and configuration files are appropriate.

## **Version**

* Documentation version for `ouf-update.sh` Version 1.1.

## **Important Notes**

* The first line of the log file should contain the date for proper log rotation.
* The `other.ini` configuration file must be correctly formatted.
* The cron job must be correctly set up to ensure proper execution.

This documentation provides a comprehensive overview of the script and its functionalities, particularly regarding the timely response to failures of the `ouf_update` service.
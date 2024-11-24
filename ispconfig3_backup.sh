#!/bin/bash

# Function to print usage
usage() {
    echo "Usage: $0 [--web-data] [--nginx]"
    echo "    --web-data    Include web data in the backup (default excludes web data)"
    echo "    --nginx       Backup Nginx config files instead of Apache2"
    exit 1
}

# Parse arguments
INCLUDE_WEB_DATA=false
USE_NGINX=false

while [[ "$1" == --* ]]; do
    case "$1" in
        --web-data)
            INCLUDE_WEB_DATA=true
            ;;
        --nginx)
            USE_NGINX=true
            ;;
        *)
            usage
            ;;
    esac
    shift
done

# Define the backup destination and filename
BACKUP_DIR="/tmp"
BACKUP_FILE="ispconfig_backup_$(date +%Y%m%d_%H%M%S).tar.gz"

# Define the default directories and files to include in the backup
INCLUDE_DIRS=(
    "/usr/local/ispconfig"
    "/etc/ispconfig"
    "/etc/postfix"
    "/etc/dovecot"
    "/etc/bind"
    "/var/vmail"  # Adjust according to where your mail data is stored
    "/var/spool/cron/crontabs"  # Cron jobs
    "/etc/letsencrypt"  # SSL certificates
)

# Add either Apache or Nginx config files based on the flag
if [ "$USE_NGINX" = true ]; then
    INCLUDE_DIRS+=("/etc/nginx/sites-available")
    INCLUDE_DIRS+=("/etc/nginx/sites-enabled")
else
    INCLUDE_DIRS+=("/etc/apache2/sites-available")
    INCLUDE_DIRS+=("/etc/apache2/sites-enabled")
fi

# Include web data if the flag is set
if [ "$INCLUDE_WEB_DATA" = true ]; then
    INCLUDE_DIRS+=("/var/www")  # Include the web data directory
fi

# Create the tar.gz backup, excluding the specified directories
echo "Starting backup..."

tar -czf "$BACKUP_DIR/$BACKUP_FILE" "${INCLUDE_DIRS[@]}"

# Verify backup file creation
if [ -f "$BACKUP_DIR/$BACKUP_FILE" ]; then
    echo "Backup successfully created: $BACKUP_DIR/$BACKUP_FILE"
else
    echo "Backup failed!"
    exit 1
fi

# Provide details for transfer to the new server
echo "You can now transfer the backup file to the new server using the following command:"
echo "scp $BACKUP_DIR/$BACKUP_FILE user@new_server:/path/to/backup/directory"

# End of script

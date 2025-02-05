#!/bin/sh

# Ensure cron uses the correct environment variables
printenv | grep MYSQL_ >> /etc/environment

# Define the cron job
cron_job="*/5 * * * * /backup.sh >> /var/log/backup.log 2>&1"

# Add the cron job
echo "$cron_job" | crontab -

# Handle SIGTERM gracefully
cleanup() {
    echo "Stopping cron..."
    pkill cron
    exit 0
}
trap cleanup TERM INT

echo "Starting cron service..."
cron -f &

# Wait for all background processes to finish
wait

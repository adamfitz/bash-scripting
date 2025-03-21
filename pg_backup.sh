#! /bin/bash

# setup vars
BACKUP_DIR="/mnt/pg_backup"
BACKUP_PREFIX="pg_backup_"
LOG_FILE="/root/postgresql_backup.log"
MAX_BACKUPS=10
MAX_DUMPS=10    # number of pg_dump files to keep


# Ensure log file exists / create it
touch "$LOG_FILE"

# 1. stop the pg service in order to cleanly copy the files

echo "$(date +"%Y-%m-%d %H:%M:%S") stopping postgresql service..." >> "$LOG_FILE"
systemctl stop postgresql


# 2. house keeping, keep only the 10 most recent backup files

# Count the number of backup files
BACKUP_COUNT=$(ls -1t "$BACKUP_DIR"/${BACKUP_PREFIX}*.tar* 2>/dev/null | wc -l)

# If 10 or more backup files remove the oldest
if [ "$BACKUP_COUNT" -ge "$MAX_BACKUPS" ]; then
    OLDEST_FILE=$(ls -1tr "$BACKUP_DIR"/${BACKUP_PREFIX}*.tar* | head -n 1)
    echo "Deleting oldest backup: $OLDEST_FILE"
    rm -f "$OLDEST_FILE"
fi

# Create new backup with timestamp
echo "$(date +"%Y-%m-%d %H:%M:%S") creating postgresql backup file..." >> "$LOG_FILE"
NEW_BACKUP="$BACKUP_DIR/${BACKUP_PREFIX}$(date +%Y-%m-%d_%H_%M_%S).tar.gz"
tar -czvf "$NEW_BACKUP" /var/lib/pgsql/data
echo "$(date +"%Y-%m-%d %H:%M:%S") Backup to location: $NEW_BACKUP completed." >> "$LOG_FILE"

# restart postgresql service
systemctl start postgresql
echo "$(date +"%Y-%m-%d %H:%M:%S") started postgresql service..." >> "$LOG_FILE"

# Count the number of dump files
DUMP_COUNT=$(ls -1t /root/pg_dumps/*.dump 2>/dev/null | wc -l)
echo "pg_dump count is: $DUMP_COUNT..." >> "$LOG_FILE"

# If 10 or more dump files remove the oldest
if [ "$DUMP_COUNT" -ge "$MAX_DUMPS" ]; then
    OLDEST_DUMP=$(ls -1tr /root/pg_dumps/*.dump | head -n 1)
    echo "Deleting oldest backup: $OLDEST_DUMP" >> "$LOG_FILE"
    rm -f "$OLDEST_DUMP"
fi

# take a snapshot of the database itself
echo "$(date +"%Y-%m-%d %H:%M:%S") creating pg_dump snapshot of mangadb..." >> "$LOG_FILE"
pg_dump -U postgres -F c -f /root/pg_dumps/pg_backup_$(date +%Y-%m-%d_%H_%M_%S).dump mangadb
echo "$(date +"%Y-%m-%d %H:%M:%S") completed pg_dump snapshot..." >> "$LOG_FILE"





# To restore the data dierctory (files)
#
# 1. Rebuild the server etc
#
# 2. Stop the pgsql service
#
# 3. unzip the backup file to the data directory (replace teh filename with the correct backup filename):
# sudo tar -xzvf ~/pg_backup_YYYY-MM-DD.tar.gz -C /
#
# 4. Make sure the postgres user permissions are set correctly
# sudo chown -R postgres:postgres /var/lib/pgsql/data
# sudo chmod 700 /var/lib/pgsql/data
#
# 5. Restart the pgsql service
#
#
# To restore the database file (logical backup) created by pg_dump (postgresql service needs to be running)
#
# pg_restore -U postgres -d $mydatabase ~/$pg_backup.dump
#


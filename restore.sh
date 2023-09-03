#!/bin/bash

# Daten im Backup
CLIENT=$(hostname -s)
BACKUP_NAME=intenso-m2-ssd

# Storagebox
STORAGEBOX=bx11
SFTP_PORT=23

# Restic
RESTIC_USER=sven
RESTIC_PASSWORD_FILE=/Users/$RESTIC_USER/.restic-password
RESTIC_REPOSITORY=/home/$CLIENT/$BACKUP_NAME/

# Liste aller Snapshots
echo "Verfügbare Backups:"
restic -r sftp:$STORAGEBOX:$RESTIC_REPOSITORY --password-file $RESTIC_PASSWORD_FILE snapshots

# Benutzer fragen, welchen Snapshot er wiederherstellen möchte
read -p "Geben Sie die ID des Snapshots ein, den Sie wiederherstellen möchten: " SNAPSHOT_ID

# Zielverzeichnis für die Wiederherstellung festlegen
read -p "Geben Sie das Verzeichnis ein, in das der Snapshot wiederhergestellt werden soll (z.B. /path/to/restore): " RESTORE_DIR

# Wiederherstellung durchführen
restic -r sftp:$STORAGEBOX:$RESTIC_REPOSITORY --password-file $RESTIC_PASSWORD_FILE restore $SNAPSHOT_ID --target $RESTORE_DIR

echo "Wiederherstellung abgeschlossen."

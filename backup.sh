#!/bin/bash

# Funktion, um Homebrew zu prüfen und zu installieren
install_brew() {
  if ! command -v brew &>/dev/null; then
    echo "Homebrew ist nicht installiert. Installation wird gestartet..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew ist bereits installiert."
  fi
}

# Funktion, um Restic zu prüfen und zu installieren
install_restic() {
  if ! brew list restic &>/dev/null; then
    echo "Restic ist nicht installiert. Installation wird gestartet..."
    brew install restic
  else
    echo "Restic ist bereits installiert."
  fi
}

# Funktion, um zu prüfen, ob ein Restic-Passwort vorhanden ist, und falls nicht, eines zu generieren
check_restic_password() {
  if [[ ! -f $RESTIC_PASSWORD_FILE ]]; then
    echo "Restic-Passwortdatei nicht gefunden. Generiere ein neues Passwort..."
    openssl rand -base64 32 > $RESTIC_PASSWORD_FILE
    chmod 600 $RESTIC_PASSWORD_FILE
    echo "Neues Passwort wurde in $RESTIC_PASSWORD_FILE gespeichert."
  else
    echo "Restic-Passwortdatei bereits vorhanden."
  fi
}

# Funktion, um zu prüfen, ob das Restic-Repository existiert, und es gegebenenfalls zu initialisieren
initialize_restic_repo() {
  # Versuch, das Verzeichnis mit `ls` aufzulisten
  if ! ssh $STORAGEBOX "ls $RESTIC_REPOSITORY" &>/dev/null; then
    echo "Restic-Repository nicht gefunden. Initialisiere neues Repository..."
    ssh $STORAGEBOX "mkdir -p $RESTIC_REPOSITORY"
    restic -r sftp:$STORAGEBOX:$RESTIC_REPOSITORY --password-file $RESTIC_PASSWORD_FILE init
  else
    echo "Restic-Repository bereits vorhanden."
  fi
}

# Hauptprogramm
install_brew
install_restic

# Zu sichernde Daten
CLIENT=$(hostname -s)
BACKUP="/Volumes/INTENSO M.2 SSD/"
BACKUP_NAME=intenso-m2-ssd

# Storagebox
STORAGEBOX=bx11

# Restic
RESTIC_USER=sven
RESTIC_PASSWORD_FILE=/Users/$RESTIC_USER/.restic-password
RESTIC_REPOSITORY=/home/$CLIENT/$BACKUP_NAME/

# Überprüfen und ggf. Restic-Passwort generieren
check_restic_password

# Überprüfen und ggf. Restic-Repository initialisieren
initialize_restic_repo

# Backup durchführen
restic -p $RESTIC_PASSWORD_FILE \
        -r sftp:$STORAGEBOX:$RESTIC_REPOSITORY \
        backup "$BACKUP"

# Snapshots vergessen, die älter als 30 Tage sind
restic -p $RESTIC_PASSWORD_FILE \
        -r sftp:$STORAGEBOX:$RESTIC_REPOSITORY \
        forget --keep-within 30d

# Nicht mehr benötigte Daten im Repository löschen
restic -p $RESTIC_PASSWORD_FILE \
        -r sftp:$STORAGEBOX:$RESTIC_REPOSITORY \
        prune

# Integrität des Repositories überprüfen
restic -p $RESTIC_PASSWORD_FILE \
        -r sftp:$STORAGEBOX:$RESTIC_REPOSITORY \
        check

# mac-restic-backup

Dieses Repository enthält zwei Skripte, die den Backup- und Wiederherstellungsprozess mit Restic auf einem macOS-System automatisieren.

## SSH-Config Beispiel

Um eine reibungslose Kommunikation mit Ihrem Backup-Server zu gewährleisten, sollten Sie einen Host-Eintrag in Ihrer SSH-Config (`~/.ssh/config`) hinzufügen. Hier ist ein Beispiel für einen solchen Eintrag:

```
Host bx11
    HostName servername.example.com
    User username
    IdentityFile ~/.ssh/id_rsa
```

Ersetzen Sie `servername.example.com` durch die tatsächliche Adresse Ihres Backup-Servers und passen Sie gegebenenfalls andere Details an.

## Backup Skript

### Funktionen

1. **Homebrew Installation**: Überprüft, ob Homebrew auf dem System installiert ist und installiert es bei Bedarf.
2. **Restic Installation**: Überprüft, ob Restic über Homebrew installiert ist und installiert es bei Bedarf.
3. **Restic Passwort**: Generiert ein zufälliges Passwort für Restic, wenn keines vorhanden ist.
4. **Restic Repository Initialisierung**: Überprüft, ob ein Restic-Repository existiert und initialisiert es bei Bedarf.
5. **Backup**: Führt ein Backup des angegebenen Verzeichnisses durch.
6. **Alte Snapshots löschen**: Vergisst Snapshots, die älter als 30 Tage sind.
7. **Aufräumen**: Löscht nicht mehr benötigte Daten im Repository.
8. **Integritätsprüfung**: Überprüft die Integrität des Repositories.

### Voraussetzungen

- macOS
- Ein konfigurierter Host-Eintrag in der SSH-Config für den Backup-Server
- SSH-Zugriff auf den Backup-Server

### Verwendung

1. Passen Sie die Konfigurationsvariablen in dem Skript nach Ihren Bedürfnissen an.
2. Machen Sie das Skript ausführbar:

   ```bash
   chmod +x backup.sh
   ```

3. Führen Sie das Skript aus.
    ```bash
   ./backup.sh
   ```

## Wichtige Empfehlung: Sichern Sie Ihr Restic-Passwort

Es ist dringend empfohlen, den Inhalt der Restic-Passwortdatei (`RESTIC_PASSWORD_FILE`) sicher aufzubewahren. Dieses Passwort wird verwendet, um Ihr Restic-Repository zu verschlüsseln und ist unerlässlich für den Zugriff auf Ihre Backups und die Wiederherstellung Ihrer Daten.

### Warum ist das so wichtig?

1. **Verschlüsselung**: Restic verwendet dieses Passwort, um Ihre Daten zu verschlüsseln. Ohne das Passwort können Sie nicht auf Ihre verschlüsselten Backups zugreifen.
   
2. **Keine Wiederherstellung**: Restic bietet keine Möglichkeit, ein verlorenes Passwort wiederherzustellen. Wenn Sie das Passwort verlieren, sind Ihre Backups im Grunde nutzlos, da sie nicht entschlüsselt werden können.

3. **Sicherheit**: Ein starkes, einzigartiges Passwort stellt sicher, dass Ihre Backups sicher sind. Wenn jemand Zugriff auf Ihr Restic-Repository erhält, aber nicht das Passwort kennt, bleiben Ihre Daten sicher und unzugänglich.

## Restore Skript

### Funktionen

1. **Liste aller Snapshots**: Zeigt alle verfügbaren Backups in Ihrem Restic-Repository an.
2. **Snapshot-Auswahl**: Ermöglicht es Ihnen, einen bestimmten Snapshot zur Wiederherstellung auszuwählen.
3. **Zielverzeichnis-Auswahl**: Ermöglicht es Ihnen, ein Verzeichnis auszuwählen, in das der Snapshot wiederhergestellt werden soll.
4. **Wiederherstellung**: Stellt den ausgewählten Snapshot im angegebenen Verzeichnis wieder her.

### Voraussetzungen

- Ein konfigurierter Host-Eintrag in der SSH-Config für den Backup-Server (wie im Hauptteil der `README.md` beschrieben).
- SSH-Zugriff auf den Backup-Server.
- Eine gesicherte Kopie des Restic-Passworts (wie im Hauptteil der `README.md` beschrieben).

### Verwendung

1. Machen Sie das Skript ausführbar:

   ```bash
   chmod +x restore.sh
   ```

2. Führen Sie das Skript aus:

   ```bash
   ./restore.sh
   ```

3. Folgen Sie den Anweisungen im Skript, um einen Snapshot zur Wiederherstellung auszuwählen und das Zielverzeichnis für die Wiederherstellung festzulegen.

### Hinweis

Stellen Sie sicher, dass Sie über die notwendigen Berechtigungen verfügen, um auf den Backup-Server zuzugreifen und dass Sie die richtigen Pfade und Einstellungen in den Konfigurationsvariablen angegeben haben.

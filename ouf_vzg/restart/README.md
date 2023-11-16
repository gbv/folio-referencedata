# OUF-Restart-Script

Das beschriebene Skript ist so konzipiert, dass es jede Minute per Cron-Job ausgeführt wird. Seine Hauptfunktion besteht darin, den Status eines bestimmten Prozesses, identifiziert durch ```ouf_update```, auf einem Unix-ähnlichen System zu überwachen und gegebenenfalls bestimmte Aktionen durchzuführen. Hier ist eine grundlegende Beschreibung seiner Funktionsweise:

## Initialisierung und Konfiguration

- Es werden Pfade für Konfigurationsdateien, Log-Verzeichnisse und Log-Dateien festgelegt.
- Eine Funktion zum sauberen Beenden des Skripts wird definiert und durch einen ```trap```-Befehl aktiviert, der bei Beendigung des Skripts aufgerufen wird.
- Ein Log-Verzeichnis wird erstellt, falls es noch nicht existiert.

## Log-Funktion

- Das Skript enthält eine Funktion zum Loggen von Nachrichten. Diese Funktion akzeptiert Log-Level und Nachrichten, um die Ausgabe entsprechend des eingestellten Log-Levels zu steuern.

## Überprüfung notwendiger Dateien:

- Es wird geprüft, ob erforderliche Konfigurationsdateien und Verzeichnisse vorhanden sind. Bei Fehlen wird eine Fehlermeldung geloggt und das Skript beendet sich.

## Hauptlogik des Skripts

- Das Skript liest eine Konfigurationseinstellung ```ouf_cron_auto_restart``` aus einer INI-Datei, um zu bestimmen, ob es weiterlaufen soll.
- Mithilfe des ```pgrep```-Befehls wird überprüft, ob der Prozess ```ouf_update``` aktuell läuft. Das Skript setzt dann eine Statusvariable ```ouf_status``` auf "running" oder "failed", abhängig davon, ob der Prozess gefunden wurde.
- Wenn der Prozess nicht läuft ("failed"), führt das Skript Befehle aus, um bestimmte Dienste (repräsentiert durch Skripte ```all_stop.sh``` und ```all_start.sh```) zu stoppen und dann neu zu starten. Diese Aktionen werden im Log protokolliert.
- Wenn der Prozess läuft ("running"), wird dies ebenfalls geloggt.

## Log-Level Steuerung

- Das Skript unterstützt zwei Log-Levels: "DEBUG" und "INFO". "DEBUG" loggt detaillierte Informationen über die Ausführung des Skripts, während - "INFO" nur kritische Nachrichten loggt, wie z.B. das Fehlen des Prozesses "ouf_update".
- Das Skript dient somit der Überwachung und automatischen Neustart-Steuerung eines spezifischen Dienstes auf einem Server. Durch die Ausführung im Minutentakt per Cron wird kontinuierlich sichergestellt, dass der wichtige Prozess ```ouf_update``` aktiv ist, und bei Bedarf werden korrigierende Maßnahmen ergriffen.

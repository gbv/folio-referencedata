# **Dokumentation für** `ouf-update.sh`

*Read this in other languages: [English](README.md), [German](README.de.md)

## **Übersicht**

`ouf-update.sh` ist ein Bash-Skript entwickelt für die Überwachung und Verwaltung von Diensten auf einem Server, speziell fokussiert auf den `ouf_update` Dienst. Das Hauptziel des Skripts ist es, auf Ausfälle von `ouf_update` zeitnah zu reagieren, indem es regelmäßig dessen Status überprüft und bei Bedarf einen Neustart der Dienste initiiert. Das Skript wird alle 60 Sekunden durch einen Cron-Job ausgeführt, um eine kontinuierliche Überwachung und schnelle Reaktion zu gewährleisten.

## **Funktionen**

### **Hauptfunktionen**

1. **Überwachung von** `ouf_update`**:**
   * Überprüft den Status des `ouf_update` Prozesses und reagiert auf dessen Ausfall.
2. **Automatischer Neustart:**
   * Startet die Dienste neu, wenn `ouf_update` nicht aktiv ist.
3. **Logging:**
   * Protokolliert wichtige Informationen und Aktionen des Skripts.
4. **Log-Rotation und Bereinigung:**
   * Rotiert täglich die Logdateien, wenn sie größer als 0 Byte sind, und behält die letzten 20 Einträge.
   * Löscht Logdateien, die älter als 30 Tage sind.

### **Konfigurationsmanagement**

* **Konfigurationsdatei (**`other.ini`):
  * `ouf_cron_auto_restart`: Steuert den automatischen Neustart (`true` oder `false`).
  * `ouf_cron_auto_restart_debug_level`: Legt das Log-Level fest (`DEBUG`, `INFO`, `OFF`).

### **Logik und Ablauf**

* **Initialisierung:** Setzt Pfade und Standardwerte.
* **Log-Verzeichnis Erstellung:** Stellt sicher, dass das Log-Verzeichnis existiert.
* **Log-Rotation:** Überprüft und rotiert die Logdateien.
* **Hauptlogik:** Überwacht den `ouf_update` Prozess und führt bei Bedarf einen Neustart der Dienste durch.

## **Ausführung**

Das Skript wird über einen Cron-Job alle 60 Sekunden ausgeführt. Diese häufige Ausführung ist entscheidend für die zeitnahe Reaktion auf Ausfälle von `ouf_update`.

## **Voraussetzungen**

* Bash-Umgebung.
* Zugriff auf Standard-Unix-Kommandos.
* Vorhandensein und korrekte Konfiguration von `profile.sh`, `all_stop.sh` und `all_start.sh`.

## **Log-Dateien**

* **Speicherort:** `/ouf-pica/log`.
* **Aktuelles Logfile:** `ouf-restart.log`.
* **Rotierte Logdateien:** `ouf-restart.log.YYYY-MM-DD`.

## **Sicherheit und Wartung**

* Überprüfen Sie regelmäßig die Log-Dateien.
* Stellen Sie sicher, dass die Berechtigungen für das Skript und die Konfigurationsdateien angemessen sind.

## **Version**

* Dokumentationsversion für `ouf-update.sh` Version 1.1.

## **Wichtige Hinweise**

* Die erste Zeile des Logfiles sollte das Datum enthalten, um eine korrekte Log-Rotation zu gewährleisten.
* Die Konfigurationsdatei `other.ini` muss korrekt formatiert sein.
* Der Cron-Job muss richtig konfiguriert sein, um eine ordnungsgemäße Ausführung zu gewährleisten.

Diese Dokumentation bietet eine umfassende Übersicht über das Skript und seine Funktionen, insbesondere im Hinblick auf die zeitnahe Reaktion auf Ausfälle des `ouf_update` Dienstes.
# KCX WebShop Jobs

Diese Business-Central-Extension enthaelt einen Monitor fuer Aufgabenwarteschlangenposten.

## Enthaltene Objekte

### Codeunit 50131 "KCX Job Queue Warning Mgt."

Diese Codeunit prueft Aufgabenwarteschlangenposten und kann direkt als Job Queue Entry eingerichtet werden.

Einrichtung in der Aufgabenwarteschlange:

- Objektart: `Codeunit`
- Objekt-ID: `50131`
- Objektname: `KCX Job Queue Warning Mgt.`
- Wiederkehrend: ja
- Intervall: z. B. alle 5 oder 15 Minuten

Die folgenden Werte werden ueber `50133 "KCX Job Queue Warning Setup"` eingerichtet:

- Aktiv/inaktiv
- E-Mail-Empfaenger
- ueberwachte Benutzer-IDs
- Minuten bis zur Warnung fuer `Ready`
- Minuten bis zur Warnung fuer `In Process`
- Betreff der Warnmail

Eine Warnmail wird versendet, wenn einer der folgenden Faelle eintritt:

- Status ist `Error`
- Status ist `Ready` und `"Earliest Start Date/Time"` liegt mehr als 1 Stunde zurueck
- Status ist `In Process` und der Posten wurde seit mehr als 1 Stunde nicht geaendert

Pro Job und Warnart wird nur einmal eine Mail versendet. Sobald der Warnfall nicht mehr aktiv ist, wird der Logeintrag entfernt. Tritt derselbe Warnfall spaeter erneut auf, wird wieder eine Mail versendet.

### Table 50132 "KCX Job Queue Warning Setup"

Setup-Tabelle fuer die Job-Queue-Warnlogik.

Wichtige Felder:

- `Active`
- `Notification Emails`
- `Monitored User IDs`
- `Ready Warning Minutes`
- `In Process Warning Minutes`
- `Warning Mail Subject`

E-Mail-Adressen und Benutzer-IDs werden mit Semikolon getrennt.

### Page 50133 "KCX Job Queue Warning Setup"

Einrichtungsseite zur Tabelle `50132`.

Beim Oeffnen wird automatisch ein `SETUP`-Datensatz erstellt, falls noch keiner vorhanden ist.

### Page 50131 "KCX Job Queue Email Test"

Testseite zum manuellen Versand einer Testmail ueber die Codeunit `50131`.

Die Testmail verwendet die Empfaenger aus `Notification Emails`.

### Table 50133 "Job Warning Log"

Speichert bereits gemeldete Warnfaelle.

Primaerschluessel:

- `"Job Queue Entry ID"`
- `"Warning Type"`

Dadurch kann die Extension unterscheiden, ob ein bestimmter Warnfall bereits gemeldet wurde.

### PermissionSet 50131 "KCX WEBSHOP JOBS"

Berechtigungssatz fuer die enthaltenen Objekte.

Enthaelt Rechte fuer:

- Codeunit `KCX Job Queue Warning Mgt.`
- Page `KCX Job Queue Email Test`
- Page/Table `KCX Job Queue Warning Setup`
- Table `Job Warning Log`

## Nicht mehr enthalten

Die Codeunit `50134 "WebShop Order Monitor JQ"` ist aktuell nicht mehr im Projekt enthalten und wird nicht exportiert.

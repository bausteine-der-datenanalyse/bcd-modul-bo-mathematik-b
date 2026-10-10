# TODO

- [X] Readme mit Aufbau des Projekts und Anleitung für content.yml, jetziges readme in installation?
- [ ] Pfade in `administration/*.bat` aktualisieren: noch ohne `lernpfad/`, `03-prepare-render.bat` bereitet nur
  `folien-r-alle` und `skript` vor, `04-render.bat` rendert nicht alle Projekte (Abgleich mit `Makefile`).
- [ ] Aufbau überlegen. Anforderungen
  - Folien für Vorlesung in Präsenz
  - Folien für Bausteine Statistik
  - Alle Folien sollten für die Studierenden einzeln als Projekt herunterladbar sein
- [ ] Folien `01-erste-schritte` (`folien-r`): Abstände in der gt-Tabelle viel zu groß. Ähnlich große
  Zeilenabstände zeigen ausgegebene Dataframes, z. B. in `09-daten-einlesen`. Vermutlich Tabellen-Stil der
  Extension `hsbo-maba`.
- [X] LaTeX aufräumen (Oktober 2026): Es sind MacTeX (`/Library/TeX/texbin`) und TinyTeX (`~/Library/TinyTeX`)
  installiert. Quarto nimmt TinyTeX, dort fehlt `xltabular` (in MacTeX vorhanden). Entweder
  `~/Library/TinyTeX/bin/universal-darwin/tlmgr install xltabular` oder `quarto uninstall tinytex`, damit
  Quarto MacTeX nimmt. Danach Skript und Aufgaben als PDF rendern (`make render-notes render-assignments`).

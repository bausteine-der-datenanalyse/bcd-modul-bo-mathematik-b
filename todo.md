# TODO

- [ ]  Aufbau umstellen, siehe `todo-umstellung-aufbau.md`.
- [ ]  Folien `01-erste-schritte` (`r-folien`): Abstände in der gt-Tabelle viel zu groß. Ähnlich große
  Zeilenabstände zeigen ausgegebene Dataframes, z. B. in `09-daten-einlesen`. Vermutlich Tabellen-Stil der
  Extension `hsbo-maba`.
- [ ]  Pfade in `administration/*.bat` aktualisieren: noch ohne `lernpfad/`, `03-prepare-render.bat` bereitet nur
  `folien-r-alle` und `skript` vor, `04-render.bat` rendert nicht alle Projekte (Abgleich mit `Makefile`).
- [ ]  `.code-workspace`-Dateien aus einer Vorlage erzeugen: Die 27 gleichen `.code-workspace`-Dateien in
  `bcd-bausteine-r/w-*/` (und `lernpfad/veranstaltung/einfuehrung/`, dort zusätzlich `ruff.enable`) sind von Hand
  kopiert. Im Oktober 2026 von Hand auf den Stand von `w-erste-schritte/folien` gebracht. Vorbild: Target `copy-templates` im Makefile von `informatik-master_2.0/unterlagen` (Vorlage in
  `bausteine/00-templates/projekt.code-workspace`). Hier z. B. Vorlage `00-templates/projekt.code-workspace` in
  `bcd-bausteine-r` und Make-Target, das sie in alle `w-*/folien/` und `w-*/aufgaben/` kopiert. Offen, ob das Target
  ins Hauptrepo oder ins Submodul gehört.
- [X]  Readme mit Aufbau des Projekts und Anleitung für content.yml, jetziges readme in installation?
- [X]  LaTeX aufräumen (Oktober 2026): Es sind MacTeX (`/Library/TeX/texbin`) und TinyTeX (`~/Library/TinyTeX`)
  installiert. Quarto nimmt TinyTeX, dort fehlt `xltabular` (in MacTeX vorhanden). Entweder
  `~/Library/TinyTeX/bin/universal-darwin/tlmgr install xltabular` oder `quarto uninstall tinytex`, damit
  Quarto MacTeX nimmt. Danach Skript und Aufgaben als PDF rendern (`make render-notes render-assignments`).

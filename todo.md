# TODO

- [X]  Tabellen in html
- [X]  Aufbau umstellen, siehe `todo-umstellung-aufbau.md`
- [X]  Extension an einer stelle installieren
- [ ]  _bcd-setup.R im Projektverzeichnis raus
- [ ]  Pre-render-skripte verteilen
- [ ]  Besseres Beispiel für Diagrammtypen, die Energieträger sind keine Häufigkeitsverteilunge k
- [ ]  Wasserwirtschaftsjahr, [www.enso.info/enso-lexikon/lemma/abflussjahr](https://www.enso.info/enso-lexikon/lemma/abflussjahr), Mail von Marco Noack vom 14.10.2026
- [ ]
- [ ]  Eigener Job für Foliensätze in `collect-content.R` (zurückgestellt, funktioniert im Moment auch so). Name
  z. B. `slides-project`, analog `assignment-paper`. Er legt fest, wie ein Foliensatz-Ordner aussieht (`folien.qmd`, `folien.code-workspace`,
  optional `bilder/`, `daten/`, `skripte/`), und erledigt Webfassung in `c/` und Zip (mit `_quarto.yml` aus
  `quarto-template.yml` und Extension) in einem Schritt.

  - Ersetzt die fast gleichen `jobs-on-parts` in `lernpfad/r-folien/content.yml` und
    `lernpfad/veranstaltung/content.yml` (dort sind die `exclude-patterns` schon auseinandergelaufen, `.graffle`).
  - Ggf. auch für `r-folien-alle` (nur Webfassung, mit `transform`) nutzbar machen.
- [ ]  Pfade in `administration/*.bat` aktualisieren: noch ohne `lernpfad/`, `03-prepare-render.bat` bereitet nur
  `folien-r-alle` und `skript` vor, `04-render.bat` rendert nicht alle Projekte (Abgleich mit `Makefile`).
- [X]  Folien `01-erste-schritte` (`r-folien`): Abstände in der gt-Tabelle viel zu groß. Ähnlich große
  Zeilenabstände zeigen ausgegebene Dataframes, z. B. in `09-daten-einlesen`. Vermutlich Tabellen-Stil der
  Extension `hsbo-maba`.
- [X]  `.code-workspace`-Dateien aus einer Vorlage erzeugen: Die 27 gleichen `.code-workspace`-Dateien in
  `bcd-bausteine-r/w-*/` (und `bausteine/veranstaltung/einfuehrung/folien/`, dort zusätzlich `ruff.enable`) sind von Hand
  kopiert. Im Oktober 2026 von Hand auf den Stand von `w-erste-schritte/folien` gebracht. Vorbild: Target `copy-templates` im Makefile von `informatik-master_2.0/unterlagen` (Vorlage in
  `bausteine/00-templates/projekt.code-workspace`). Hier z. B. Vorlage `00-templates/projekt.code-workspace` in
  `bcd-bausteine-r` und Make-Target, das sie in alle `w-*/folien/` und `w-*/aufgaben/` kopiert. Offen, ob das Target
  ins Hauptrepo oder ins Submodul gehört.
- [X]  Readme mit Aufbau des Projekts und Anleitung für content.yml, jetziges readme in installation?
- [X]  LaTeX aufräumen (Oktober 2026): Es sind MacTeX (`/Library/TeX/texbin`) und TinyTeX (`~/Library/TinyTeX`)
  installiert. Quarto nimmt TinyTeX, dort fehlt `xltabular` (in MacTeX vorhanden). Entweder
  `~/Library/TinyTeX/bin/universal-darwin/tlmgr install xltabular` oder `quarto uninstall tinytex`, damit
  Quarto MacTeX nimmt. Danach Skript und Aufgaben als PDF rendern (`make render-statistik-skript render-aufgaben`).

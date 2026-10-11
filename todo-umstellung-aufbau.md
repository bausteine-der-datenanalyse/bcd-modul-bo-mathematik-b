# TODO: Aufbau der Unterlagen umstellen

Die Veranstaltung ist ein inverted classroom. Vieles wird in Videos erklärt, die auf Folien beruhen. Einiges
bespreche ich in Präsenz, z. B. die Einführung oder die Grundprinzipien von ggplot. Jede Woche gibt es
Aufgabenblätter. In Moodle liegen alle Unterlagen an einer Stelle, die Wochen-Tabs enthalten nur Agenda und Links.
Informatik Master ist bereits so umgestellt.

## Grundsatz

- **Material** ist nach Themen geordnet und über Jahre stabil (Skript, Folien, Aufgaben). Es liegt in den Bausteinen.
- **Ablauf** (welche Woche was, Agenda, Tempo) steht nur in Moodle, nicht im Repo.
- Ob ein Foliensatz in Präsenz oder im Video verwendet wird, ist keine Eigenschaft der Folien, sondern des Ablaufs.
- Was nur zu dieser Veranstaltung gehört (Einführung, Studienarbeit), bindet die allgemeinen Bausteine an die
  Vorlesung an, ähnlich wie `index.qmd` im Skript.

## Zielaufbau

| Was                                        | Ort                                | Projekt hier                                  |
|--------------------------------------------|------------------------------------|-----------------------------------------------|
| Skript Statistik                           | `m-*/skript`                       | `lernpfad/statistik-skript` (aus `skript`)    |
| Folien Statistik (Grundlage für Videos)    | `m-*/folien` (neu)                 | `lernpfad/statistik-folien` (neu)             |
| Folien R                                   | `w-*/folien`                       | `lernpfad/r-folien` (aus `folien-r`)          |
| Folien R, Gesamtfassung                    | `w-*/folien`                       | `lernpfad/r-folien-alle` (aus `folien-r-alle`) |
| Aufgabenblätter, ein Blatt pro Abschnitt   | `m-*/aufgaben`, `w-*/aufgaben`     | `lernpfad/aufgaben`                           |
| Einführung, Studienarbeit … (mit Zip)      | lokal                              | `lernpfad/veranstaltung` (aus `folien`)       |
| Wochenablauf                               | nur Moodle                         | –                                             |

Projektnamen nach dem Muster `<quelle>-<art>`, damit Zusammengehöriges nebeneinander steht. Die URLs auf GitHub
Pages ändern sich dadurch; unkritisch, weil Moodle ohnehin neu aufgebaut wird.

## Schritte

- [X]  Projekte umbenennen: `skript` → `statistik-skript`, `folien-r` → `r-folien`, `folien-r-alle` →
  `r-folien-alle`
  - Ordner, `output-dir` in `_quarto.yml`, `deploy-folder` in `content.yml`, Makefile (inkl. `SLIDES_PDF_DIRS`,
    `clean`), ggf. `.github/workflows/build.yaml`.
  - `aufgaben/content.yml` kopiert `lernpfad/folien-r/quarto-template.yml` – Pfad anpassen.
  - Links in `README.md` und in der README von `bcd-bausteine-statistik` (Gesamtdokument Skript).
  - PDF-Name `skript-mathematik-b.pdf` bleibt.

- [X]  `lernpfad/folien` → `lernpfad/veranstaltung`
  - Folien nach Themen statt Wochen, je Foliensatz ein Ordner (`einfuehrung/`, später `studienarbeit/`) mit
    `folien.qmd`, `folien.code-workspace`, `bilder/`, `daten/`, `skripte/`.
  - Neue `content.yml` wie bei `r-folien` (HTML + Zip mit `_quarto.yml` und Extension), `parts` auf die lokalen
    Ordner. Die Einführung dient Studierenden als Beispiel für komplexere Grafiken.
  - `woche-1` wird `einfuehrung` (inkl. `_beispiel-essen.qmd`, `extremtage.R`, `d_extremtage_de.RData`).
  - Agenda-Folien `woche-2` bis `woche-11` entfallen, nicht mehr benötigte Bilder/Daten entfernen.
  - Prüfen: entpacktes Zip rendert in leerem Ordner.
  - Makefile (`prepare-render`, `render-slides`, `SLIDES_PDF_DIRS`, `clean`) anpassen, Ausgabe nach
    `_output/veranstaltung`.
- [ ]  `_beispiel-essen.qmd` in `einfuehrung/folien.qmd` übernehmen, statt per `include` einzubinden. Dann
  entfallen die beiden eigenen `copy`-Jobs dafür in `lernpfad/veranstaltung/content.yml` (und ggf. `_work.qmd`).
- [ ]  Eigener Job für Foliensätze in `collect-content.R` (Name z. B. `slides-project`), analog
  `assignment-paper`. Er legt fest, wie ein Foliensatz-Ordner aussieht (`folien.qmd`, `folien.code-workspace`,
  optional `bilder/`, `daten/`, `skripte/`), und erledigt Webfassung in `c/` und Zip (mit `_quarto.yml` aus
  `quarto-template.yml` und Extension) in einem Schritt.
  - Ersetzt die fast gleichen `jobs-on-parts` in `lernpfad/r-folien/content.yml` und
    `lernpfad/veranstaltung/content.yml` (dort sind die `exclude-patterns` schon auseinandergelaufen, `.graffle`).
  - Ggf. auch für `r-folien-alle` (nur Webfassung, mit `transform`) nutzbar machen.
  - Vorher `_beispiel-essen.qmd` übernehmen (siehe oben), damit es keine Sonderfälle gibt.
  - README von `bcd-bausteine-montieren` ergänzen.
- [ ]  Aufgabenblätter nach Abschnitten statt Terminen (zurückgestellt)
  - Blätter bleiben nummeriert, damit man einfach darauf verweisen kann.
  - Lücke bei Blatt 08: Blatt 07 umfasst zwei R-Projekte (`weitere-geoms-und-plots-aufbereiten`,
    `grundlagen-r`), deren Zips die Nummern 07 und 08 tragen. Das doppelte `increment-index` hält Blatt- und
    Zip-Nummern gleich, die `skip`-Einträge in `parts` stehen für die Blätter 01 und 02 ohne R-Projekt.
  - Die Zip-Namen mit Nummer stehen fest in den Aufgabentexten von `bcd-bausteine-r` (z. B.
    `03-einzelne-merkmale-aufgaben.zip`). Möglichkeiten: Blatt 07 teilen, oder Zips ohne Nummer benennen und die
    Texte anpassen (dann kennen die allgemeinen Bausteine keine Nummern dieser Veranstaltung mehr).
- [ ]  Statistik-Folien in `bcd-bausteine-statistik`
  - Je Modul `m-*/folien/` neben `skript/` und `aufgaben/`, gleich gegliedert wie das Skript.
  - Format `hsbo-maba-revealjs`.
  - Gemeinsame Daten/R-Hilfsfunktionen von Skript und Folien in einen Ordner auf Modulebene (z. B.
    `m-*/gemeinsam/`) statt `skript/01-daten/`. Erst angehen, wenn es die ersten echten Folien gibt.
- [ ]  Neues Projekt `lernpfad/statistik-folien` analog `r-folien`
  - Offen, ob Studierende die Folien bekommen (HTML/PDF/Zip) oder nur die Videos. Tendenz: nur Videos, sie
    sollen das Skript lesen.
  - PDF für Goodnotes über `make render-slides-pdf`.
- [X]  Aufbau in `README.md` (Tabelle Projekte) und `CLAUDE.md` festhalten (bei den offenen Schritten ergänzen).

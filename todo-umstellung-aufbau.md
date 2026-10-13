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


| Was                                       | Ort                            | Projekt hier                                   |
| ------------------------------------------- | -------------------------------- | ------------------------------------------------ |
| Skript Statistik                          | `m-*/skript`                   | `lernpfad/statistik-skript` (aus `skript`)     |
| Folien Statistik (Grundlage für Videos)  | `m-*/folien` (neu)             | `lernpfad/statistik-folien` (neu)              |
| Folien R                                  | `w-*/folien`                   | `lernpfad/r-folien` (aus `folien-r`)           |
| Folien R, Gesamtfassung                   | `w-*/folien`                   | `lernpfad/r-folien-alle` (aus `folien-r-alle`) |
| Aufgabenblätter, ein Blatt pro Abschnitt | `m-*/aufgaben`, `w-*/aufgaben` | `lernpfad/aufgaben`                            |
| Einführung, Studienarbeit … (mit Zip)   | lokal                          | `lernpfad/veranstaltung` (aus `folien`)        |
| Wochenablauf                              | nur Moodle                     | –                                             |

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
- [X]  `_beispiel-essen.qmd` in `einfuehrung/folien.qmd` übernehmen, statt per `include` einzubinden. Dann
  entfallen die beiden eigenen `copy`-Jobs dafür in `lernpfad/veranstaltung/content.yml` (und ggf. `_work.qmd`).
- [X]  Links auf Moodle aktualisieren (nach dem Push, wenn GitHub Pages neu gebaut ist). Basis-URL
  `https://bausteine-der-datenanalyse.github.io/bcd-modul-bo-mathematik-b/`, darunter:


  | Alt                                      | Neu                                                     |
  | ------------------------------------------ | --------------------------------------------------------- |
  | `skript/index.html`                      | `statistik-skript/index.html`                           |
  | `skript/skript-mathematik-b.pdf`         | `statistik-skript/skript-mathematik-b.pdf`              |
  | `skript/c/NN-name.html` (Kapitel)        | `statistik-skript/c/NN-name.html`                       |
  | `folien-r/c/NN-name.html`                | `r-folien/c/NN-name.html`                               |
  | `folien-r/c/NN-name.zip`                 | `r-folien/c/NN-name.zip`                                |
  | `folien-r-alle/index.html`               | `r-folien-alle/index.html`                              |
  | `folien/woche-1.html`                    | `veranstaltung/c/01-einfuehrung.html` (neu auch `.zip`) |
  | `folien/woche-2.html` … `woche-11.html` | entfallen, Agenda steht im Wochen-Tab                   |

  - Die Seite `moodle/installation-r-positron.html` enthält keine Links auf GitHub Pages.
- [ ]  Statistik-Folien in `bcd-bausteine-statistik`

  - Je Modul `m-*/folien/` neben `skript/` und `aufgaben/`, gleich gegliedert wie das Skript.

  - [X]  Erste Folien: `m-statistische-daten/folien/folien.qmd`.

  - Keine Kopien: Folien nutzen Bilder, Daten und R-Hilfsfunktionen des Skripts über `../skript/`
    (`../skript/00-bilder/…`, R per `withr::with_dir("../skript", source("01-daten/<name>.R"))`).

  - [X]  Format: Folien nur als PDF, mit Typst (auch das Skript soll längerfristig auf Typst umgestellt werden).
    Extension `kazuyanagimoto/quarto-touying-typst` (Format `touying-typst`, Theme `clean-theme` aus dem
    Typst-Paket `touying-quarto-clean`), vorerst in `bcd-bausteine-statistik/_extensions/`. Klassen
    (`neuerbegriff`, `ja`, `nein`) über `commands:` und `_bcd-setup.typ` (Gegenstück zu `_bcd-setup.tex`),
    Typst-Zweig in `_bcd-setup.R`, Tabellen mit tinytable statt gt.
  - [X]  Typst-Folienformat jetzt `tinh-slides-typst` in der neutralen Extension `quarto-tinh` (statt in
    `hsbo-maba`), siehe `todo-quarto-extension-2.md`.
  - [X]  CI von `bcd-bausteine-statistik` anpassen: Folien werden vorerst nur lokal gebraucht. `build.yaml` rendert
    jetzt `for f in m-*/skript m-*/aufgaben`, dazu `GITHUB_TOKEN` beim Setup von Quarto (vorher 403 bei TinyTeX).
    In der CI scheiterte Typst beim Herunterladen von `@preview/touying` (access denied, Quarto 1.9.20).
  - [X]  Makefile von `bcd-bausteine-statistik` anpassen: Die Targets `html` und `pdf` rendern
    `quarto render $folder -t html` bzw. `-t pdf` für jeden Ordner `m-*` und erzwingen damit das Format auch
    für `folien/`. Skript/Aufgaben und Folien trennen, z. B. eigenes Target `folien` mit
    `quarto render m-*/folien/folien.qmd`.
  - [ ]  Titelfolie ausbauen (Untertitel, Autor, Datum, Aussehen der Hochschule).
  - [ ]  Beim Zusammensetzen (`lernpfad/statistik-folien/content.yml`) berücksichtigen, dass die Folien auf
    `../skript/` zugreifen: Bilder, Daten und R-Dateien des Skripts so nach `c/` kopieren, dass die Pfade
    stimmen (oder Pfade per `transform` umschreiben). Ebenso `../../_bcd-setup.typ` im Kopf der Folien.
- [X]  Neues Projekt `lernpfad/statistik-folien` analog `r-folien`

  - Nur PDF (Typst), kein HTML und keine Zips. Offen, ob Studierende die PDFs bekommen oder nur die Videos.
    Tendenz: nur Videos, sie sollen das Skript lesen.
  - PDF direkt in Goodnotes, `make render-slides-pdf` (decktape) wird dafür nicht gebraucht.
- [X]  Aufgabenblätter nach Themen statt Terminen

  - [X]  Ein Blatt je Thema, Blätter bleiben nummeriert, damit man einfach darauf verweisen kann. Nummern laufen
    deshalb nicht mit Wochen oder Skriptkapiteln gleich (Hinweis dazu in Moodle). Blatt 02 (Statistische Daten)
    und Blatt 03 (Grundlagen von ggplot2) getrennt, folgende Blätter um eins verschoben.
  - [X]  Zip-Namen in den Aufgabentexten per Platzhalter `${zipfile}` (siehe `collect-content.R`), nicht mehr fest.
  - [X]  Lücke bei Blatt 09: Blatt 08 (Plots aufbereiten und Grundlagen R) umfasst zwei R-Projekte
    (`weitere-geoms-und-plots-aufbereiten`, `grundlagen-r`), deren Zips die Nummern 08 und 09 tragen. Das doppelte
    `increment-index` hält Blatt- und Zip-Nummern gleich, die `skip`-Einträge in `parts` stehen für die Blätter 01
    und 02 ohne R-Projekt. Möglichkeit: Blatt 08 teilen.
- [ ]  Aufbau in `README.md` (Tabelle Projekte) und `CLAUDE.md` festhalten (bei den offenen Schritten ergänzen).
- [ ]  Eigener Job für Foliensätze in `collect-content.R` (zurückgestellt, funktioniert im Moment auch so). Name
  z. B. `slides-project`, analog `assignment-paper`. Er legt fest, wie ein Foliensatz-Ordner aussieht (`folien.qmd`, `folien.code-workspace`,
  optional `bilder/`, `daten/`, `skripte/`), und erledigt Webfassung in `c/` und Zip (mit `_quarto.yml` aus
  `quarto-template.yml` und Extension) in einem Schritt.

  - Ersetzt die fast gleichen `jobs-on-parts` in `lernpfad/r-folien/content.yml` und
    `lernpfad/veranstaltung/content.yml` (dort sind die `exclude-patterns` schon auseinandergelaufen, `.graffle`).
  - Ggf. auch für `r-folien-alle` (nur Webfassung, mit `transform`) nutzbar machen.
  - Vorher `_beispiel-essen.qmd` übernehmen (siehe oben), damit es keine Sonderfälle gibt.
  - README von `bcd-bausteine-montieren` ergänzen.

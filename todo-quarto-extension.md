# TODO: Mathematik B auf die Quarto-Extension umstellen

Die Extension `hsbo-maba` enthält das gemeinsame Aussehen meiner Lehrveranstaltungen
(Repo `matthiasbaitsch/quarto-hsbo-maba`, lokal `~/sciebo/lehrveranstaltungen/quarto-hsbo-maba`).
Informatik Master ist bereits umgestellt (Oktober 2026) und dient als Vorbild.

- Formate: `hsbo-maba-revealjs`, `hsbo-maba-html`
- Einbinden: `quarto add matthiasbaitsch/quarto-hsbo-maba`, `_extensions/` einchecken
- Stiländerungen nur im Extension-Repo, pushen, dann `quarto update matthiasbaitsch/quarto-hsbo-maba`

## Umfang

Umgestellt werden nur die Foliensätze `folien` und `folien-r` (revealjs). `skript`, `aufgaben`,
`folien-r-alle` und `weitere-unterlagen` bleiben unverändert: Ihr Stil (`bcd-style-notes.css`,
`_bcd-setup.tex`, `latex-environment`) kommt aus den BCD-Bausteinen.

Da Mathematik B aus mehreren eigenständigen Quarto-Projekten besteht, liegt die Extension in zwei
Kopien: `folien/_extensions/` und `folien-r/_extensions/`.

## Ausgangslage (aus der Bestandsaufnahme)

- `folien/style.scss` und `folien-r/bcd-style-slides.scss` sind ältere Fassungen des Informatik-Stils
  (32px statt 30px, andere Abstände, Code kleiner). Mit der Extension sehen die Folien daher anders aus –
  das ist gewollt. Kein systematischer PDF-Vergleich nötig, die Folien werden im Semester ohnehin
  Woche für Woche überarbeitet.
- Gemeinsame revealjs-Optionen (`lang`, `overview`, `slide-number`, `code-line-numbers`) stecken in der
  Extension; neu hinzu kommen `transition: fade` und MathJax 4.
- Bekannte, harmlose Konsolenmeldung mit MathJax 4: `Cannot read properties of undefined (reading 'Config')`.
- BCD-Submodule (`bcd-bausteine-montieren`, `bcd-bausteine-r`, `bcd-bausteine-statistik`) gehören zum
  Gemeinschaftsprojekt und bleiben unverändert.

## Voraussetzung: Extension ergänzen

- [X]  Rahmen für `.framed` und `.raw` wie in `bcd-bausteine-r/bcd-style-slides.scss` (in Mathe B bisher
  ohne Stil, `.imagesource` bleibt undefiniert)
- [X]  `90` in der `@each`-Liste für `.up`/`.down` ergänzt (`[]{.down90}` in
  `bcd-bausteine-r/w-kenngroessen/folien/folien.qmd`)
- [X]  Version 0.2.0 getaggt und gepusht

## Folien als PDF

- [X]  Make-Targets analog Informatik (dort im `Makefile`: `render-slides-pdf`, `save-slides-pdf`,
  `diff-slides-pdf`): `_output/folien/woche-*.html`, `_output/folien-r/c/*.html`

## `folien` umstellen

- [X]  `quarto add matthiasbaitsch/quarto-hsbo-maba` in `folien/`
- [X]  `_quarto.yml`: `revealjs` → `hsbo-maba-revealjs`, Optionen entfernen, die die Extension schon setzt
  (`lang`, `overview`, `slide-number`, `code-line-numbers`, `theme`)
- [X]  `style.scss` löschen

## `folien-r` umstellen

- [X]  `quarto add matthiasbaitsch/quarto-hsbo-maba` in `folien-r/`
- [X]  Zuerst testen: Finden die Web-Folien unter `folien-r/c/` die Extension in `folien-r/_extensions/`? (ja)
- [X]  `quarto-template.yml`: `revealjs` → `hsbo-maba-revealjs`, `theme: bcd-style-slides.scss` und die
  Optionen aus der Extension entfernen (übrig bleibt im Wesentlichen `execute: echo: true`)
- [X]  `content.yml`: beide `bcd-style-slides.scss`-Jobs entfernen, dafür die Extension in die Zip-Ordner
  kopieren, damit die Studierenden lokal rendern können. Der `copy`-Job in `collect-content.R` kopiert
  Ordner nicht rekursiv, daher den Extension-Ordner direkt angeben:
  ```yaml
  - copy:
    from: _extensions/matthiasbaitsch/hsbo-maba
    to: ${target-folder}/${idx}-${name}/_extensions/matthiasbaitsch/hsbo-maba
  ```
- [X]  `bcd-style-slides.scss` löschen
- [X]  Ein Zip entpacken und lokal rendern (`09-daten-einlesen`, inkl. `.framed`)

## Allgemein

- [X]  Logo der Titelseite festlegen. Die Extension nimmt standardmäßig das HS-Bochum-Logo (Variable
  `$title-logo` in `titlepage.scss`). Überschreiben per eigener SCSS-Datei ist noch nicht getestet.
- [X]  Make-Target `update-extension` wie in Informatik, aber für beide Ordner (`folien`, `folien-r`)

## CI

- [ ]  Workflow prüfen (`make render`, Checkout mit Submodulen), `_extensions/` in beiden Ordnern im Checkout
  vorhanden

## Folien und Aufgaben erste Schritte

- [X]  Text in `bcd-bausteine-r/w-erste-schritte/folien/folien.qmd` von RStudio auf Positron umgestellt
  (noch nicht committet)
- [X]  Bilder in `w-erste-schritte/folien/bilder/` erstellen (werden in `folien.qmd` schon referenziert):
  - `positron.svg`: Screenshot der Oberfläche mit Bereichen 1–4 (Editor, Variablen, Konsole, Plots/Hilfe),
    ersetzt `rstudio.svg`
  - `quarto-markdown-positron.svg`: Editor mit `.qmd`-Datei, beschriftet (Preview/Render, Chunk ausführen,
    alle Chunks ausführen …), ersetzt `quarto-markdown-rstudio.svg`
  - `logos.svg` (Quelle `logos.afdesign`): RStudio-Logo durch Positron-Logo ersetzen
- [X]  Alte RStudio-Bilder (`rstudio.svg`, `quarto-markdown-rstudio.svg`) löschen oder nach `bilder/alt/` verschieben
- [X]  Aufgabe ggf. ergänzen

## Ordnerstruktur wie Informatik

- [ ]  `folien`, `folien-r` usw. in einen Unterordner `lernpfad/` verschieben (Informatik: `lernpfad/aufgaben`,
  `lernpfad/folien`, `lernpfad/folien-alle`, …). Festlegen, welche Ordner dazugehören.
- [ ]  Relative Pfade anpassen: `output-dir` und `pre-render` in den `_quarto.yml`, `deploy-folder` und Pfade in
  den `content.yml`, Aufrufe von `collect-content.R` und `SLIDES_PDF_DIRS` im `Makefile`, `.gitignore` (`*/c`)
- [ ]  Prüfen, ob sich die URLs auf GitHub Pages ändern (Links in Moodle)

## Dokumentation

- [ ]  CLAUDE.md um Hinweis auf die Extension ergänzen (nur `folien`, `folien-r`; zwei Kopien)
- [ ]  README der Extension um Mathe-Besonderheiten ergänzen

## Folien-PDFs in der CI

- [ ]  Ggf. veröffentlichen und in der CI erzeugen (Informatik: Node und decktape im Workflow,
  `make publish PDF_JOBS=2 DECKTAPE_ARGS=--chrome-arg=--no-sandbox`)
- [ ]  PDFs auf der Titelfolie verlinken wie in Informatik (`lernpfad-zusammenstellen.jl` fügt
  `[⬇ Folien als PDF](name.pdf){download="name.pdf"}` vor der ersten Überschrift ein)
  - `folien-r`: `collect-content.R` kann nur zeilenweise ersetzen, nicht einfügen
  - Vorschlag: Lua-Filter in der Extension, per `pdf-download: true` eingeschaltet, Dateiname aus der
    Eingabedatei. Nur für die Webseite einschalten (`folien/_quarto.yml`, eigene Metadaten-Datei für
    `folien-r/c/`), nicht in den Zips
  - Alternative für `folien`: Zeile von Hand in die `woche-*.qmd`

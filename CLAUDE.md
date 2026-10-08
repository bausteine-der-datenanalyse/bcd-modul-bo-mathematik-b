# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Projektüberblick

Lehrmaterial für das Modul "Mathematik B" (Statistik und Datenanalyse) im Master-Studiengang
Bauingenieurwesen/Umweltingenieurwesen der Fachhochschule Bochum, erstellt mit
[Quarto](https://quarto.org/) und R. Veröffentlichung erfolgt automatisch auf GitHub Pages beim Push
auf `main`. Sechs unabhängige Quarto-Projekte, fünf davon in `lernpfad/` (wie im Informatik-Projekt):

- `lernpfad/skript` – Skript (HTML + PDF)
- `lernpfad/aufgaben` – Aufgabenblätter (HTML + PDF)
- `lernpfad/folien` – Foliensatz (revealjs)
- `lernpfad/folien-r` – R-Folien
- `lernpfad/folien-r-alle` – Gesamtfassung der R-Folien (HTML + PDF, in CI/Makefile nur HTML gerendert)
- `weitere-unterlagen` – sonstiges Material

Die Ausgabe landet unabhängig davon in `_output/<projekt>` (z. B. `_output/folien`), die URLs auf GitHub
Pages enthalten also kein `lernpfad/`.

## Bausteine-Architektur (wichtig!)

Inhalte werden nicht direkt in den Projektordnern geschrieben, sondern aus drei externen
"Bausteine"-Repos zusammengesetzt, die als Git-Submodule unter `bausteine/` eingebunden sind
(`bcd-bausteine-statistik`, `bcd-bausteine-montieren`, `bcd-bausteine-r`).

Jedes Quarto-Projekt (außer `folien`) hat eine `content.yml`, die als Job-Pipeline für
`bausteine/bcd-bausteine-montieren/collect-content.R` dient: Sie kopiert/transformiert Dateien aus
den Bausteine-Repos in einen lokalen Zielordner, standardmäßig `c/` (siehe `target-folder` in
`content.yml`).

**`c/` (bzw. der in `target-folder` angegebene Ordner) wird bei jedem Lauf von
`collect-content.R` geleert und neu befüllt – niemals direkt darin editieren.** Inhaltliche
Änderungen gehören entweder in die Quelle im jeweiligen `bausteine/*`-Submodul oder in die
`content.yml`, die den Kopiervorgang steuert.

`folien` hat kein `content.yml` und wird direkt aus den `.qmd`-Dateien im Ordner gerendert.

Pfade in `content.yml` (`parts`, `deploy-folder`, `${project-folder}`) sind relativ zum Repo-Root, einfache
Dateinamen bei `copy` (z. B. `quarto-template.yml`) relativ zum Projektordner. Der `copy`-Job kopiert Ordner
**nicht rekursiv**, nur die Dateien direkt darin.

## Quarto-Extension `hsbo-maba`

`lernpfad/folien` und `lernpfad/folien-r` nutzen die Extension `hsbo-maba` (Repo
`matthiasbaitsch/quarto-hsbo-maba`, lokal `~/sciebo/lehrveranstaltungen/quarto-hsbo-maba`) mit dem Format
`hsbo-maba-revealjs`. Sie enthält das gemeinsame Aussehen der Folien (auch für Informatik), z. B. die Klassen
`.up*`/`.down*`, `.framed`, `.raw`.

- Die Extension liegt in zwei Kopien: `lernpfad/folien/_extensions/` und `lernpfad/folien-r/_extensions/`
  (eingecheckt). `folien-r/content.yml` kopiert sie zusätzlich in jedes Zip, damit Studierende lokal rendern
  können.
- Stiländerungen nur im Extension-Repo, dort Version erhöhen, taggen, pushen, dann hier `make update-extension`.
- `skript`, `aufgaben`, `folien-r-alle` und `weitere-unterlagen` nutzen die Extension nicht; ihr Stil
  (`bcd-style-notes.css`, `_bcd-setup.tex`) kommt aus den BCD-Bausteinen.

## Befehle

```bash
make prepare-render   # führt collect-content.R für skript, aufgaben, folien-r, folien-r-alle,
                       # weitere-unterlagen aus (füllt jeweils c/)
make render           # rendert alle sechs Projekte (render-slides, render-slides-r, render-notes, …)
make render-slides-pdf # Folien (folien, folien-r) per decktape als PDF, save-/diff-slides-pdf zum Vergleich
make update-extension  # Extension hsbo-maba in folien und folien-r aktualisieren
make clean             # entfernt _output sowie alle generierten c/, .quarto, _bcd-setup.* etc.
make update-from-github  # git pull + Submodule aktualisieren
make bootstrap         # installiert R-Paketabhängigkeiten (aus DESCRIPTION)
```

Einzelnes Projekt rendern (nach `prepare-render`, sofern das Projekt eine `content.yml` hat):

```bash
quarto render lernpfad/skript
quarto render lernpfad/folien-r-alle -t html   # PDF-Format hier bewusst ausgelassen
```

R-Pakete werden über `DESCRIPTION` (Paketname `bcdstatistik`) verwaltet:

```r
remotes::install_deps(upgrade = "always")
```

R-Lint-Konfiguration liegt in `.lintr` (Zeilenlänge 120, Einrückung 4).

## CI

`.github/workflows/build.yaml` (Job `render`) ruft `make render` auf und lädt `_output` als Pages-Artifact
hoch; der Job `deploy` published anschließend auf GitHub Pages. Das Makefile ist damit die
maßgebliche Quelle für den Renderprozess – Änderungen am Ablauf gehören dort hin, nicht in den
Workflow.

## Bekannte Stolpersteine

- Codeblöcke, die per `{{< include datei.csv >}}` Rohdateien unverändert anzeigen sollen, müssen
  `{.raw}` (Klasse) statt `{raw}` (Engine) verwenden – sonst meldet `knitr` "Unknown language
  engine 'raw'".

## Umstellung altes LaTeX-Skript → Quarto

Das alte LaTeX-Skript liegt in `/Users/maba/sciebo/mathematik-fbb/mathematik-b/01-skript.old` (Kapitel
`NN-name/01-k-name.tex`). Kapitel werden nach und nach zu Modulen `m-<name>/skript/skript.qmd` in
`bausteine/bcd-bausteine-statistik` umgestellt (Formatierung siehe dort `style.md`). Dabei gilt:

- Text neben Bild (`\mbildmittext`, `minipage` usw.) wird untereinander gesetzt – Bild neben Text funktioniert in
  Quarto nicht gut.
- Mit R erstellte Grafiken (`00-pics-r/00-R/*.R`) werden als R-Code in das qmd übernommen, nicht als Bild: Daten
  und Hilfsfunktionen in `01-daten/<name>.R` (per `source()` im ersten Chunk), der Plot-Code selbst in Chunks im
  qmd (Vorbild: `m-zwei-merkmale`).
- Sonstige Bilder als SVG in `00-bilder/`.

## Verwandtes Projekt

Die Vorlesung **Informatik Master Bauingenieurwesen** (OOP mit C#) unter
`~/sciebo/lehrveranstaltungen/informatik-master_2.0/unterlagen` ist ebenfalls auf Quarto umgestellt. Gleiches
Grundmuster (Bausteine → Skript setzt zusammen → Quarto rendert → GitHub Pages), aber andere Umsetzung: Bausteine
direkt im Repo statt als Submodule, Zusammensetzen per Julia statt R, eine zentrale `_quarto.yml`, CI ruft die
Render-Schritte selbst auf statt des Makefiles. Bei Fragen zu Vergleich oder Angleichung dort nachsehen.

## Hinweise zur Zusammenarbeit

- Notizen und Erinnerungen gehören in diese Datei (`CLAUDE.md`)
- Kein Memory-Verzeichnis anlegen – weder im Projekt noch anderswo. Das eingebaute auto-memory-System nicht verwenden.

## Arbeitshinweise für Claude

- Auf Fragen („wie geht das besser?", „wie soll ich X nennen?") nur erklären – Code erst ändern, wenn der Nutzer
  ausdrücklich darum bittet oder eine konkret vorgeschlagene Änderung bestätigt. Das gilt auch, wenn die Frage
  Unzufriedenheit ausdrückt („das ist doch Fummelei").
- Als Dezimaltrennzeichen wird bewusst der Punkt verwendet (in Folien, Grafiken und Inline-Ausgaben). Fehlende
  Dezimalkommas nicht als Fehler melden, keine `decimal.mark = ","`-Umstellung vorschlagen.
- Beim Gegenlesen von Folien nur Inhalt, Text und sichtbares Ergebnis prüfen. Keine ungefragten Nebenprüfungen wie
  das Nachschlagen von CSS-Klassen in `style.scss` – selbst gesetzte Klassen/Styles als gewollt annehmen.

## CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

### 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

### 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

### 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.
